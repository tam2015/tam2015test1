# == Schema Information
#
# Table name: boxes
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text
#  closed        :boolean          default(FALSE)
#  price         :decimal(, )
#  favorite      :boolean          default(FALSE)
#  account_id    :integer
#  customer_id   :integer
#  dashboard_id  :integer
#  created_at    :datetime
#  updated_at    :datetime
#  meli_order_id :integer
#  status        :string(255)      default("0")
#  closed_at     :datetime
#  user_id       :integer
#  meli_item_id  :string(40)
#  tags          :string(255)      is an Array
#

class Box < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  include Provider::ModelBase

  default_scope  { order(:meli_date_created => :desc) }

  #associations
  has_many   :payments, class: ::Mercadolibre::Payment
  has_one    :shipping, class: ::Mercadolibre::Shipping
  #has_many   :feedbacks
  belongs_to :account
  belongs_to :customer
  belongs_to :dashboard
  belongs_to :user



  # STATUS
    # confirmed:  Initial state of an order, and it has no payment yet.
    # paid:  The order has a related payment and it has been accredited.
      # ML -> to AirCRM
      # payment_required: The order needs a payment to become confirmed and show users information.
      # payment_in_process: There is a payment related with the order, but it has not accredited yet.
    # cancelled:  The order has not completed by some reason.
    # to_send:  Order ready to be sent..
    # shipped:  Order sent.
    # delivered:  Order delivered.
    # rated:  Qualified order by the seller and buyer.
    # archived:  Order filed manually or automatically.
    # locked (invalid):  The order has been invalidated as it came from a malicious buyer.
  # enum status:          %w(confirmed paid cancelled to_send shipped delivered rated archived locked)

  scope :created_in_last    , -> (start_date) { where(created_at: start_date.ago.beginning_of_day..Time.current) }
  scope :total_price_por_day, -> (          ) { select("date(created_at) as ordered_date, sum(price) as total_price").group("date(created_at)").reorder("") }

  scope :where_statuses, -> (query) { where(Box.query_normalize_enum(query)) }

  after_create  :increment_account_counter
  after_destroy :decrement_account_counter
  after_create  :increment_dashboard_counter
  after_destroy :decrement_dashboard_counter


  # Verifica quais attributos possuem enum
  # quando possui converte para o index (valor salvo no banco como integer)
  def self.query_normalize_enum query
    defined_enums.map do |k, v|
      k = k.to_sym
      if query.include?(k)
        query[k] = v[query[k]]
      else
        query.delete k
      end
    end

    query
  end

  # Example of scope to enum
  # scope :open, -> {
  #   where('status <> ? OR status <> ?', STATUS[:resolved], STATUS[:rejected])
  # }


  def create_or_update_order(dashboard, meli_order)
    puts "# Box.create_or_update_order"

    @dashboard  = dashboard
    @account    = dashboard.account
    @user       = dashboard.users.last

    box         = ::Box.where(meli_order_id: meli_order.id).first_or_initialize


    ##
    # Customer
    # Customer needs to be parsed before because the box_to_customers association is different than others (shipping and payment)
    if meli_order.buyer? and meli_order.seller
      customer = ::Customer.parse(meli_order.buyer, meli_order.seller)
    end

    # Parse necessary attributes from meli_order into a hash
    # to update Box
    order_hash  = parse_order_to_hash(meli_order)
    order_hash.merge!({
      #from parse
      customer_id:      customer.id,

      #associations
      dashboard_id: @dashboard.id,
      account_id:   @account.id,
      user_id:      @user.id,
      })

    # Calculate if box type is recent or archived
    if order_is_archived? meli_order.date_created
      order_hash[:status] = :archived
    end

    # Update Box
    box.update(order_hash)

    # Parse meli_order associations:
    #   Item,
    #   Payment
    #   Shipping
    #   Feedback
    parse_order_associations meli_order, box
  end


  def parse_order_to_hash(order)
    {
      meli_order_id:    order.id,
      meli_item_id:     order.order_items[0].item.id,

      name:             order_title(order),
      description:      order_description(order),
      status:           order.status?,
      tags:             order.tags?,

      meli_date_created:       order.date_created?.to_s,
      meli_last_updated:       order.last_updated?.to_s,
      meli_date_closed:        order.date_closed?.to_s,
      price:            order.total_amount?
    }
  end

  ##
  # TODO:
  #   Every parser that hits the API
  #   should fire an asynchronous task
  #   to perform the request
  ##
  def parse_order_associations(meli_order, box)
    # puts "* ORDER: #{meli_order.class} \n #{meli_order.inspect} \n\n "
    # puts "* BOX: #{box.class}" # , #{box.inspect}"

    ##
    # Item {API Request}
    # Orders can hold old products that Meli doesn't list to us
    # We still need to fetch these Items from Meli
    meli_order.order_items.map do |meli_item|
      ::Mercadolibre::ItemWorker.perform_async @dashboard.meli_user_id, meli_item.item.id
    end

    ##
    # Questions {API Request}
    #


    ##
    # Payment {Parse from meli_order.payments}
    # Box Payment can be partialy parsed from a Meli::Order object
    ::Mercadolibre::Payment.parse meli_order, box
    # ...and we complement Payment objects requesting from Meli
    # meli_order_payment_ids = meli_order.payments.map(&:id)
    # puts "\n\n* Meli Payment IDs: #{meli_order_payment_ids.inspect}\n\n"
    # meli_order_payment_ids.each do |meli_payment_id|
    #   ::Mercadolibre::PaymentWorker.perform_async @dashboard.id, meli_payment_id
    # end


    ##
    # Shipping {Parse from meli_order.shipping}
    # Box Shipping can be completly parsed from a Meli::Order object
    #
    ::Mercadolibre::Shipping.parse meli_order, box
    # ...and we complement Shipping objects requesting from Meli
    # If Shipping.status is :to_be_agreed,
    # means that there is no Shipping association
    # to be retrieved from Meli
    unless meli_order.shipping.status.to_sym == :to_be_agreed
      ::Mercadolibre::ShippingWorker.perform_async @dashboard.id, meli_order.id, box.id
    end


    ##
    # Feedback {Parse from meli_order.feedback}
    ::Mercadolibre::Feedback.parse @dashboard.id, meli_order

    # {From Meli}: There's a rule that feedback remains hidden
    # to the other part until both parts have sent feedback,
    # or after 21 days. Whatever happens first will show
    # the other part feedback to an user.
    # --
    # meli_order.feedback.purschase will be "nil" until
    # Seller gives his feedback then we are able to fetch
    # Purchase feedback again and if it is "nil",
    # update will income from Mercadolibre::Hooks


    # if meli_order.feedback.sale == nil and meli_order.date_created > Time.now - 21.days
    #   puts "* Feedback: No sale present"
    #   ::Mercadolibre::FeedbackWorker.perform_async :post_sale_feedback, @dashboard.id, meli_order.id
    # end

    # if meli_order.feedback.sale.present? ||
    #    meli_order.feedback.purchase.present?
    #    puts "* Feedback: Sale and/or Purchase are present"
    #   ::Mercadolibre::FeedbackWorker.perform_async :retrieve_item_feedback, @dashboard.id, meli_order.id
    #  end


    if meli_order.feedback.sale == nil and 
      meli_order.date_created > Time.now - 21.days and 
      @dashboard.aircrm_preferences.where(preference_type:"seller_feedback_message").first and
      @dashboard.aircrm_preferences.where(preference_type:"seller_feedback_message").first.data != nil and      
      @dashboard.aircrm_preferences.where(preference_type:"seller_feedback_message").first.data[:status] == "active" and 
      box.payments.first.tags.present and
      box.payments.first.tags.include? @dashboard.aircrm_preferences.where(preference_type:"seller_feedback_message").first.data[:payment_status] and
      box.shipping.tags.present and
      box.shipping.tags.include? @dashboard.aircrm_preferences.where(preference_type:"seller_feedback_message").first.data[:shipping_status]  

      puts "* Feedback: No sale present"
      ::Mercadolibre::Feedback.post_seller_feedback @dashboard.id, meli_order.id
    end

    if meli_order.feedback.sale.present? || meli_order.feedback.purchase.present?
       puts "* Feedback: Sale and/or Purchase are present"
      ::Mercadolibre::Feedback.get_meli_feedback @dashboard.id, meli_order.id
    end

  end





























































  # #################### #
  #        Helpers       #
  # #################### #
  def title
    name
  end

  def total_amount
    number_to_currency self.price
  end

  # #################### #
  #  Virtual attributes  #
  # #################### #
  # Shipping
  # def shipping(refresh = false)
  #   if !defined?(@shipping) or refresh
  #     @shipping = Mercadolibre::Shipping.where(box_id: id).first
  #   end
  #   @shipping
  # end

  #customer
  def box_customer
    @customer = Customer.where(id: customer_id).first
  end

  # Feedback
  def feedback(refresh=true)
     if !defined?(@feedback) or refresh
      @feedback = Mercadolibre::Feedback.where(meli_order_id: meli_order_id, author_type: "buyer").first
     end
     @feedback
  end

  def feedback?
    !!feedback
  end

  def feedback_seller(refresh=true)
    if !defined?(@feedback_seller) or refresh
     @feedback_seller = Mercadolibre::Feedback.where(meli_order_id: meli_order_id, author_type: "seller").first
    end
    @feedback_seller
  end

  def feedback_already_updated
    @feedback = Mercadolibre::Feedback.where(meli_order_id: meli_order_id, author_type: "seller").first
    feedback_seller.updated == true
  end

  # Counter cache
  def increment_account_counter
    self.account.increment!(:boxes_count) if self.account
  end

  def decrement_account_counter
    self.account.decrement!(:boxes_count) if self.account
  end

  def increment_dashboard_counter
    self.dashboard.increment!(:boxes_count) if self.dashboard
  end

  def decrement_dashboard_counter
    self.dashboard.decrement!(:boxes_count) if self.dashboard
  end

  #virtual attribute - box_order_items
  def item
    item_mid = meli_item_id if meli_item_id.present?
    if item_mid
      item = Mercadolibre::Item.where(meli_item_id: item_mid).first
    end
  end

  def box_item_variation box
    item = box.item box
    if item and item.variations.present? #and item.variations.first.item.variation_attributes.present?
      box.order_items.first.item.variation_attributes.each do |variation|
        puts "#{variation.name + " " + variation.value_name}"
      end
    end
  end

  #virtual attribute to count notifications Class:Notify
  def box_notify_count
    @notifications = Notify.where(meli_order_id: meli_order_id).count
  end


  def payment_difference (box)
    payed = box_payment_transaction_amount (box)
    listed = box.price
    @payment_difference = listed - price
  end

  def to_meli
    hash = serializable_hash
    hash["id"] = meli_order_id
    Meli::Order.new hash, !new_record?
  end

  #{"message":"You can not tag the order as not_paid or not_delivered manualy.","error":"automatic_tag","status":403,"cause":null}
  def update_tags_from_payment_changes(box, payment=nil, params=nil)
    @params_from_user = params[:mercadolibre_payment] if params
    @box = box
    @dashboard = box.dashboard
    @payment = payment
    # Avoid inline conditionals when there is more than 1 condition
    @tag_of_payment = @payment.status.to_s if @payment and @payment.status and @params_from_user == nil
    @tag_of_payment = @params_from_user["status"] if @params_from_user != nil

    if @payment != nil and update_come_from_payment_parse(@box, @payment, @params_from_user)
      @box.update_all_tags(@box, @dashboard, @payment, @tag_of_payment, @params_from_user)
    elsif @payment != nil and payment_update_come_from_user_status_form(@box, @payment, @params_from_user)
      @box.update_all_tags(@box, @dashboard, @payment, @tag_of_payment, @params_from_user)
    else
     puts "Não é possível atualizar pois o pedido é do MercadoPago e os status serão atualizados automaticamente pelo MercadoPago"
    end
  end

  # Too many parameters.
  def update_all_tags(box, dashboard, payment, tag_of_payment, params_from_user)
    payment.tags = [] << tag_of_payment
    payment.save

    # Avoid inline conditionals when there is more than 1 condition
    tag_of_shipping = box.shipping.tags[0] if box.shipping and box.shipping.tags.present? and box.shipping.tags != nil and params_from_user != nil

    if box and box.status != "archived" and !box.tags.include?(tag_of_payment)
      order = box.to_meli


      #temporary solution to fix the bug "order was being modified that came from sidekiq"
      box.tags = []
      box.tags << tag_of_payment
      box.tags << tag_of_shipping if tag_of_shipping.present? and tag_of_shipping != tag_of_payment
      box.tags_will_change!      
      box.save


      # order.tags = []
      # order.tags << tag_of_payment
      # order.tags << tag_of_shipping if tag_of_shipping.present? and tag_of_shipping != tag_of_payment
      # order.save

      #temporary removed
      # record_from_meli = Meli::Order.find box.meli_order_id
      # if record_from_meli
      #   #box_tags = [] if box.tags == nil
      #   box.tags = record_from_meli.tags if record_from_meli and record_from_meli.tags.present?
      #   box.tags_will_change!
      #   box.save
      # end
    end
  end

  # Avoid too many spaces: It difficults the reading
  def update_come_from_payment_parse(box, payment, params_from_user)
    (params_from_user == nil) &&
    (payment.accept_mercadopago == true) &&
    (payment.present?) &&
    (payment.status.present? if payment)
  end

  def payment_update_come_from_user_status_form(box, payment, params_from_user)
    (payment.accept_mercadopago == false) &&
    (params_from_user != nil)
  end

  #{"message":"You can not tag the order as not_paid or not_delivered manualy.","error":"automatic_tag","status":403,"cause":null}
  def update_tags_from_shipping_changes(box, shipping=nil, params=nil)
      @params_from_user = params[:mercadolibre_shipping] if params
      puts "thiago_teste_params - #{@params_from_user}"
      @box = box
      @dashboard = box.dashboard
      @shipping = shipping
      @tag_of_shipping = @shipping.status.to_s if @shipping and @shipping.status and @params_from_user == nil
      @tag_of_shipping = @params_from_user["status"] if @params_from_user != nil

      if @shipping != nil and update_come_from_shipping_parse(@box, @shipping, @params_from_user)
        # @box.update...(@box)? You are passing the instance variable to its own instance variable
        # It should be refatored to @box.update....(@dashboard....)
        @box.update_all_tags_of_shipping(@box, @dashboard, @shipping, @tag_of_shipping)
      elsif @shipping != nil and update_come_from_user_status_form(@box, @shipping, @params_from_user)
        @box.update_all_tags_of_shipping(@box, @dashboard, @shipping, @tag_of_shipping)
      else
        #
       puts "Não é possível atualizar pois o pedido é do MercadoPago e os status serão atualizados automaticamente pelo MercadoPago"
      end

  end

  # refactor param 'box'
  def update_all_tags_of_shipping(box, dashboard, shipping, tag_of_shipping)
    # this is an instance method which can access its box without passing as a parameter
    # 'box' is an instance variable which can be accessed simply as "box" or modified with "self.box".
    shipping.tags = [] << tag_of_shipping
    shipping.save

    tag_of_payment =  box.payments.first.tags[0] if box.payments.first and box.payments.first.tags.present? and box.payments.first.tags != nil

    if box and box.status != "archived" and !box.tags.include?(tag_of_shipping)
      order = box.to_meli

      #temporary solution to fix the bug "order was being modified that came from sidekiq"
      box.tags = [] if box.tags == nil
      box.tags = box.tags << tag_of_shipping
      box.tags = box.tags << tag_of_payment if tag_of_payment.present? and tag_of_payment != tag_of_shipping and tag_of_payment != []
      box.tags_will_change!
      box.save

      # order.tags = []
      # order.tags = order.tags << tag_of_shipping
      # order.tags = order.tags << tag_of_payment if tag_of_payment.present? and tag_of_payment != tag_of_shipping and tag_of_payment != []
      # order.save


      #temporary removed  
      # record_from_meli = Meli::Order.find box.meli_order_id
      # #if record_from_meli != 404
      # box_tags = [] if box.tags == nil
      # box.tags = record_from_meli.tags if record_from_meli and record_from_meli.tags.present?
      # box.tags_will_change!
      # box.save
      # #end
    end
  end

  def update_come_from_shipping_parse(box, shipping, params_from_user)
    (params_from_user                                   == nil                                              ) &&
    (shipping.shipping_mode                             == "me1" || shipping.shipping_mode == "me2"         ) #&&
    # (shipping.present?                                                                                    ) &&
    # (shipping.status.present?                                                            if shipping      )
  end

  def update_come_from_user_status_form(box, shipping, params_from_user)
    (shipping.shipping_mode                             == "not specified" || shipping.shipping_mode == "custom"         ) &&
    (params_from_user                                   != nil                                                           )
  end


































    private

      def order_title(order_object)
        new_title = []
        new_title << "##{order_object.id}"

        unless order_object.order_items.empty?
          item = order_object.order_items[0]
          new_title << [item.quantity, item.item.title].compact.join(" ")
        end

        if order_object.total_amount?
          new_title << number_to_currency(order_object.total_amount)
        end

        new_title.compact.join(" - ")
      end


      def order_description(order_object)
        desc = []

        unless order_object.order_items.empty?
          item = order_object.order_items[0]
          price = number_to_currency(item.unit_price)
          desc << "Quantitade Vendida: #{item.quantity}"
          desc << "Cód Produto: #{    item.item.id   }"
          desc << "Nome Produto: #{   item.item.title}"
          desc << "Preço Unitário: #{ price     }"
          total = (item.quantity || 0) * (item.unit_price || 0)
          desc << "Valor total: #{ number_to_currency(total) }"
          desc.join("\n")
        else
          "no description"
        end
      end

      # Calculates if Item has more than 21 days
      def order_is_archived?(publish_date)
        difference = (Time.current.end_of_day - Time.parse(publish_date).beginning_of_day)
        difference > 21.days
      end



end
