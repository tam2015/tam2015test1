module Mercadolibre
  class Shipping < ActiveRecord::Base
    include Provider::ModelBase
    serialize :receiver_address
    #dúvidas
    # include Geocoder::Model::Mongoid
    has_one :NotifyAgent, as: "sender"
    has_one :NotifyAgent, as: "receiver"
    has_one :label
    belongs_to :box

    alias_attribute :date_created, :created_at

    enum status: [ :to_be_agreed, :pending, :handling, :ready_to_ship, :shipped, :delivered, :not_delivered, :cancelled ]

    #geocoded_by :receiver_address_s
    #before_save :normalize#, on: [:save, :create, :update]
    before_save :update_pendings
    before_save :update_pendings_status

    #before_save :geocode

    # Associations
    def dashboard(refresh = false)
      if !defined?(@dashboard) or refresh
        @dashboard = ::Dashboard.find(self.dashboard_id)
      end
      @dashboard
    end

    def dashboard?
      !!dashboard
    end

    def box(refresh = false)
      if !defined?(@box) or refresh
        @box = ::Box.find(self.box_id)
      end
      @box
    end

    def box?
      !!box
    end

    def update_pendings
      self.pendings = []

      if self.receiver_address.present?
        self.pendings << "no_street"     if !self.receiver_address[:street_name    ].present?
        self.pendings << "no_number"  if !self.receiver_address[:street_number  ].present?
        self.pendings << "no_zipcode"     if !self.receiver_address[:zip_code       ].present?
        self.pendings << "no_city"  if !self.receiver_address[:city           ].present?
      else
        self.pendings << "no_address"
      end
    end

    def update_pendings_status
      self.pendings_status = "no_pending"

      [ "no_street", "no_number", "no_zip_code",
        "no_city", "no_address" ].each do |pedding_message|
        if self.pendings.include?(pedding_message)
          self.pendings_status = "pending"
          break
        end
      end
    end




    def self.verifier
      @verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.secrets.address_update_key)
    end

    def self.verify(token)
      verifier.verify(token)
    end

    # API methods
    # Providers::Mercadolibre::Shipping.get dashboard
    def self.get(dashboard)
      dashboard = Dashboard.find(dashboard) if dashboard.kind_of?(Fixnum) or dashboard.kind_of?(String)

      # Filters
        # "shipping.status" => "to_be_agreed", # empty address
      filters = {
        seller: dashboard.meli_user_id,
        sort: "date_desc"
      }

      orders = self.api.get_all_orders filters
      # begin
      # rescue => e
      #   e
      # end
    end

    def self.get!(dashboard)
      dashboard = Dashboard.find(dashboard) if dashboard.kind_of?(Fixnum) or dashboard.kind_of?(String)

      orders = self.get dashboard

      Rails.logger.debug "\n\n ===o=== #{orders}"

      # Em caso orders não ser uma array retorn o erro (orders é um response)
      orders unless orders.kind_of?(Array)

      # self.update_orders(orders, dashboard)
    end

    ##
    # Parse Shipping information from Order
    #   @meli_order   {Meli::Order}
    #   @box          {Marcadolibre::Box}
    #
    # Check app-docs/meli-partial-order.json
    # to preview Meli::Order data structure
    def self.parse(meli_order, box)
      puts "* Mercadolibre::Shipping.parse..."

      # Rescue or Initialize a shipping for meli_order.id
      shipping = Mercadolibre::Shipping.find_or_create_by(meli_order_id: meli_order.id)

      # Associations
      shipping.dashboard_id         = box.dashboard_id.to_i
      shipping.box_id               = box.id.to_i
      shipping.meli_order_id        = meli_order.id
      shipping.meli_item_id         = meli_order.order_items[0].item.id

      # If Shipping Status is to_be_agreed means that
      # there is no more information about it.
      # We create Shipping to have a model with an association
      # and explicit status of to_be_agreed
      if meli_order.shipping.status.to_sym == :to_be_agreed
        shipping.status             =  :to_be_agreed
        shipping.shipping_mode      =  "not specified"

      elsif meli_order.shipping.id.present?
        meli_order_shipping         = meli_order.shipping

        shipping.meli_shipping_id   = meli_order_shipping.id
        shipping.status             = meli_order_shipping.status
        shipping.shipping_mode      = meli_order_shipping.shipping_mode
        shipping.shipment_type      = meli_order_shipping.shipment_type
        shipping.cost               = meli_order_shipping.cost?
        shipping.date_first_printed = meli_order_shipping.date_first_printed?

        # tracking - attributes available only when fetching from API
        #shipping.tracking_number = meli_order_shipping.tracking_number?
        #shipping.tracking_method = meli_order_shipping.tracking_method?
        if meli_order_shipping.status_history?
          shipping.date_shipped    = meli_order_shipping.status_history.date_shipped
          shipping.date_delivered  = meli_order_shipping.status_history.date_delivered
        end

        # label infos
        #sender_address:       shipping_hash.sender_address,
        if !meli_order_shipping.receiver_address.nil? and
          shipping.updated_by_seller == false and
          shipping.updated_by_customer == false
            shipping.receiver_address    = meli_order_shipping.serializable_hash[:receiver_address]
        end

        shipping.accept_mercadoenvios= true

        # Data Collection for post analysis
        # Datastores.create!(from: :meli_order_shipping,
        #                   meli_id: meli_order_shipping.id,
        #                   klass: meli_order_shipping.class,
        #                   json: meli_order_shipping.serializable_hash)

      end

      if shipping.save
        box.update_tags_from_shipping_changes(box, shipping, params=nil)
      end

    end


    def notify(box, type = :no_address)
      Rails.logger.debug "########################  Shipping notify!  #############################"
      Rails.logger.info " ===  box: #{box.id} (#{box})  ==="
      Rails.logger.info " ===  box.customer: #{box.customer.id} (#{box.customer})  ==="
      Rails.logger.info " ===  type: #{type} (#{type.class})  ==="

      return unless box.customer
      # return unless box.user and box.customer
      full_name = box.customer.name.split(" ")

      receiver = NotifyAgent.new({
        # type:         "buyer",
        meli_user_id: box.customer.meli_user_id,
        full_name:  box.customer.name,
        first_name: full_name.shift,
        last_name:  full_name.join(" "),
        nickname:   box.customer.nickname,
        email:      box.customer.email,
        phone:      box.customer.phone,
        created_at: box.customer.created_at,
        updated_at: box.customer.updated_at
      })

      # sender = NotifyAgent.new({
      #   type:       "seller",
      #   id:         box.user.id,
      #   uid:        box.user.id,
      #   first_name: box.user.first_name,
      #   last_name:  box.user.last_name,
      #   nickname:   box.user.username,
      #   email:      box.user.email,
      #   phone:      box.user.phone,
      #   created_at: box.user.created_at,
      #   updated_at: box.user.updated_at
      # })

      Rails.logger.debug "\n\n\n\n\n\n\n thiago_json------- #{receiver.to_json}"
      notify = ::Notify.where(reference_id: self.id.to_s, reference_model: self.model_name.to_s).first_or_initialize
      notify.param        = type.to_sym || :no_address
      notify.receiver     = receiver
      # notify.sender       = sender
      notify.dashboard_id = box.dashboard.id.to_s
      notify.box_id       = box.id.to_s
      notify.meli_order_id = box.meli_order_id.to_s

      Rails.logger.info " ===  notify.param: #{notify.param} ==="
      saved = notify.save
      notify
    end

    def generate_token(notify_id=nil)
      self.class.verifier.generate(id.to_s)
    end



    # Helpers

    def empty?
      receiver_address_s? and !receiver_address_s.empty?
    end

    def title(full=true)
      return unless receiver_address?
      _address = []
      _address << receiver_address["street_name"  ]
      _address << receiver_address["street_number"]
      _address << receiver_address["comment"      ] if full
      _address = _address.compact

      _address.join(", ") unless _address.empty?
    end

    def region(short = false)
       return unless receiver_address?
      _address = []
      _address << receiver_address["city"    ]["name"] if receiver_address["city"]
      _address << receiver_address["state"   ]["name"] if receiver_address["state"]
      _address << receiver_address["country" ]["name"] if short and receiver_address["country"]
      _address = _address.compact

      _address.join(", ") unless _address.empty?
    end

    def zip_code
      return unless receiver_address?
      receiver_address["zip_code"]
    end

    def to_s
      return unless self.receiver_address?
      [self.title, self.region].compact.join(" - ")
    end
    def normalize
      self.receiver_address_s= self.to_s
      self.geocode
    end

    def normalize!
      normalize
      save!
    end

  end
end

