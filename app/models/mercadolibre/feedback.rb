module Mercadolibre
  class Feedback < ActiveRecord::Base
    include Provider::ModelBase

    # belongs_to :box
    alias_attribute :date_created, :created_at

    default_scope  { order(:meli_order_id => :desc) }


    def self.provided_by
      :mercadolibre
    end

    # Get feedback
    def self.get_feedbacks(box)
      order_id = box.meli_order_id
      begin
        @feedback = ::Dashboard.api.get_buyer_feedback(order_id)
        Rails.logger.debug "\n\n ::ML::Feedback::: #{@feedback.inspect}"
        @feedback
      rescue => e
        e
      end
    end

    ##
    # Parse Feedbacks information from Order
    #   @meli_order   {Meli::Order}
    #   @box          {Marcadolibre::Box}
    #
    # Check app-docs/meli-partial-order.json
    # to preview Meli::Order data structure
    def self.parse(dashboard_id, meli_order)

      # Create Buyer feedback is available
      if meli_order.feedback.purchase.present?
        feedback_buyer                         = Mercadolibre::Feedback.where(meli_order_id: meli_order.id, author_type: "buyer").first_or_initialize
        meli_order_feedback                    = meli_order.feedback.purchase

        feedback_buyer.meli_date_created       = meli_order_feedback.date_created?
        feedback_buyer.rating                  = meli_order_feedback.rating?
        feedback_buyer.fulfilled               = meli_order_feedback.fulfilled?

        puts "\n\n* MESSAGE? Purchase - #{meli_order.id} #{meli_order_feedback.inspect}\n\n"

        # attributes available only when fetching from API
        feedback_buyer.reason                  = meli_order_feedback.reason?
        feedback_buyer.message                 = meli_order_feedback.message?
        #feedback_buyer.reply        = meli_order_feedback.reply?

        feedback_buyer.status                  = meli_order_feedback.status?

        # Associations
        feedback_buyer.meli_item_id            = meli_order.order_items[0].item.id
        feedback_buyer.dashboard_id            = dashboard_id

        feedback_buyer.save

      else # create empty objects
        feedback_buyer                         = Mercadolibre::Feedback.where(meli_order_id: meli_order.id, author_type: "buyer").first_or_initialize
        feedback_buyer.meli_item_id            = meli_order.order_items[0].item.id
        feedback_buyer.dashboard_id            = dashboard_id
        feedback_buyer.save
      end

      # Create Seller feedback is available
      if meli_order.feedback.sale.present?
        feedback_seller                        = Mercadolibre::Feedback.where(meli_order_id: meli_order.id, author_type: "seller").first_or_initialize
        meli_order_feedback                    = meli_order.feedback.sale

        feedback_seller.meli_date_created      = meli_order_feedback.date_created?
        feedback_seller.rating                 = meli_order_feedback.rating?
        feedback_seller.fulfilled              = meli_order_feedback.fulfilled?

        puts "\n\n* MESSAGE? Sale - #{meli_order.id} #{meli_order_feedback.inspect}\n\n"

        # attributes available only when fetching from API
        feedback_seller.reason                 = meli_order_feedback.reason?
        feedback_seller.message                = meli_order_feedback.message?
        #feedback_seller.reply        = meli_order_feedback.reply?

        feedback_seller.status                 = meli_order_feedback.status?

        # Associations
        feedback_seller.meli_item_id           = meli_order.order_items[0].item.id
        feedback_seller.dashboard_id           = dashboard_id

        feedback_seller.save

      else # create empty objects

        feedback_seller                        = Mercadolibre::Feedback.where(meli_order_id: meli_order.id, author_type: "seller").first_or_initialize
        feedback_seller.meli_item_id           = meli_order.order_items[0].item.id
        feedback_seller.dashboard_id           = dashboard_id
        feedback_seller.save
      end

      # Data Collection for post analysis
      # Datastores.create!(from: :meli_order_feedback,
      # meli_id: meli_order.id,
      # klass: meli_order.feedback.class,
      # json: meli_order.feedback.serializable_hash)
    end


    def self.update_record(from, dashboard_id, meli_order_id, meli_order_feedback)
      case from.to_sym
        when :retrieve_item_feedback    then   self.update_feedback(dashboard_id, meli_order_id, meli_order_feedback)
        when :post_sale_feedback        then   self.update_feedback_from_post(dashboard_id, meli_order_id, meli_order_feedback)
      end
    end

    # When it comes from a Meli::Order parser
    # with a "feedback" attribute
    def self.update_feedback(dashboard_id, meli_order_id, meli_order_feedback)
      puts "* update_feedback: #{meli_order_feedback.to_json}"
      # Create Buyer feedback is available
      if  meli_order_feedback.purchase.present? and meli_order_feedback.purchase.id.present?

        feedback_buyer                         = Mercadolibre::Feedback.where(meli_order_id: meli_order_id, author_type: "buyer").first_or_initialize
        feedback_purchase                      = meli_order_feedback.purchase

        feedback_buyer.meli_feedback_id        = feedback_purchase.id
        feedback_buyer.meli_date_created       = feedback_purchase.date_created?
        feedback_buyer.rating                  = feedback_purchase.rating?
        feedback_buyer.fulfilled               = feedback_purchase.fulfilled?

        # attributes available only for replying a feedback
        feedback_buyer.reason                  = feedback_purchase.reason?
        feedback_buyer.message                 = feedback_purchase.message?
        # feedback_buyer.reply        = feedback_purchase.reply?

        feedback_buyer.status                  = feedback_purchase.status?

        feedback_buyer.save
      end

      # Create Seller feedback is available
      if  meli_order_feedback.sale.present? and meli_order_feedback.sale.id.present?

        feedback_seller                        = Mercadolibre::Feedback.where(meli_order_id: meli_order_id, author_type: "seller").first_or_initialize
        feedback_sale                          = meli_order_feedback.sale

        feedback_seller.meli_feedback_id       = feedback_sale.id
        feedback_seller.meli_date_created      = feedback_sale.date_created?
        feedback_seller.rating                 = feedback_sale.rating?
        feedback_seller.fulfilled              = feedback_sale.fulfilled?

        # attributes available only when fetching from API
        feedback_seller.reason                 = feedback_sale.reason?
        feedback_seller.message                = feedback_sale.message?
        #feedback_seller.reply        = feedback_sale.reply?

        feedback_seller.status                 = feedback_sale.status?

        feedback_seller.restock_item           = feedback_sale.restock_item?

        feedback_seller.save
      end
    end

    # When it comes from a Meli::Feedback post parser
    # JSON structure is a bit different:
    # {"status"=>"hidden",
    # "reason"=>nil,
    # "site_id"=>"MLB",
    # "date_created"=>"2015-01-16T13:56:32.301-04:00",
    # "cust_role"=>"seller",
    # "reply_status"=>nil,
    # "id"=>9040175062958,
    # "message"=>"Bom comprador.",
    # "cust_from"=>172340300,
    # "fulfilled"=>true,
    #  "reply_date"=>nil,
    #   "visibility_date"=>nil, "cust_to"=>172340277, "reply"=>nil, "rating"=>"NEUTRAL"}
    #
    def self.update_feedback_from_post(dashboard_id, meli_order_id, meli_order_feedback)

      feedback_seller                   = Mercadolibre::Feedback.where(meli_order_id: meli_order_id, author_type: "seller").first_or_initialize #meli_order_feedback.cust_role)

      feedback_seller.meli_feedback_id  = meli_order_feedback.id
      feedback_seller.rating            = meli_order_feedback.rating.downcase
      feedback_seller.fulfilled         = meli_order_feedback.fulfilled

      # attributes available only when fetching from API
      feedback_seller.reason            = meli_order_feedback.reason?
      feedback_seller.message           = meli_order_feedback.message?
      #feedback_seller.reply             = meli_order_feedback.reply?

      feedback_seller.meli_date_created = meli_order_feedback.date_created?.to_date.to_s
      feedback_seller.author_type       = "seller"#meli_order_feedback.cust_role

      feedback_seller.status            = meli_order_feedback.status

      feedback_seller.save
    end


    def self.get_meli_feedback(dashboard_id, meli_order_id)
      if meli_order_id
        # Fetch Feedbacks from Meli
        meli_order_feedback  = Meli::Feedback.find_by_order_id(meli_order_id)

        # Update Feedbacks
        Mercadolibre::Feedback.update_record(:retrieve_item_feedback, dashboard_id, meli_order_id, meli_order_feedback)
      end
    end

    def self.post_seller_feedback(dashboard_id, meli_order_id)
    dashboard = ::Dashboard.find_by(id: dashboard_id)
    raise ArgumentError, "Invalid dashboard element.\n dashboard_id=`#{dashboard_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)
      if meli_order_id

        params = {
          "fulfilled" => true,
          "rating"    => dashboard.aircrm_preferences.first.data[:rating],
          "message"   => dashboard.aircrm_preferences.first.data[:content]
        }
        # Post seller Feedback on Meli
        meli_order_feedback  = Meli::Feedback.post_feedback(meli_order_id, params)

        puts "\n\n ** Sale Feedback posted: #{meli_order_feedback.inspect}"
      end
    end

    def self.post_seller_feedback_from_form(dashboard_id, meli_order_id, feedback_data)
    dashboard = ::Dashboard.find_by(id: dashboard_id)
    raise ArgumentError, "Invalid dashboard element.\n dashboard_id=`#{dashboard_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)
      if meli_order_id
        # Post seller Feedback on Meli
        refresh_token = dashboard.credentials[:refresh_token]
        Mercadolibre::Feedback.api.update_token(refresh_token)
        # meli_order_feedback  = Meli::Feedback.post_feedback(meli_order_id, feedback_data)
        meli_order_feedback  = Mercadolibre::Feedback.api.give_feedback_to_order(meli_order_id, feedback_data)


        puts "\n\n ** Sale Feedback posted: #{meli_order_feedback.inspect}"
      end
    end

    def self.meli_update(order_id, kind, feedback_data, dashboard)
      #update token before feedback posting
      refresh_token = dashboard.credentials[:refresh_token]
      Mercadolibre::Feedback.api.update_token(refresh_token)

      #using old mercadolivre gem
      @feedback = ::Dashboard.api.change_feedback_from_order(order_id, kind, feedback_data)
    end

































    # Get feedback
    def self.get_seller_feedback(box)
      #Rails.logger.debug "@ ::Mercadolibre::Feedback.rb: get_seller_feedback!"
      order_id = box.meli_order_id
      begin
        @feedback = ::Dashboard.api.get_seller_feedback(order_id)
        @feedback
      rescue => e
        e
      end
    end

    # Get and save feedback
    def self.get_seller_feedback!(box, args={})
      @feedback = self.get_seller_feedback box

      if @feedback and @feedback.status != 404 #and @feedback.rating

        feedback = where(meli_order_id: box.id.to_i, author_type: "seller").first_or_initialize

        feedback_params = {
          rating:     @feedback.rating,
          fulfilled:  @feedback.fulfilled,

          reason:     @feedback.reason,
          message:    @feedback.message,
          #reply:      @feedback.reply,

          status:     @feedback.status,

          # Associations
          meli_item_id: @feedback.meli_item_id,
          dashboard_id: box.dashboard_id
        }

        feedback.update(feedback_params)
      # else
      #   @feedback
      end
      feedback
    end

    def self.post(order_id, feedback_data)
      if ::Dashboard.api.get_seller_feedback(order_id).status == 404 #validação para ver se ordem já possui feedback seller - Segunda checagem
        @feedback = ::Dashboard.api.give_feedback_to_order(order_id, feedback_data)
      end
    end

    def self.create_seller_feedback_automatically meli_order
      #Rails.logger.debug "@ ::Mercadolibre::Feedback.rb: create_seller_feedback!"
      box = ::Box.where(meli_order_id: meli_order.id).first
      dashboard = box.dashboard
      if box.feedback_seller box == nil

        order_id = box.meli_order_id


        feedback_data = {
          rating: "positive",
          fulfilled: true,
          message: "Comprador excelente"
        }

        #unless Meli::Base.oauth_connection.expired?
          @ml_seller_feedback = self.post(order_id, feedback_data)
          if @ml_seller_feedback and !@ml_seller_feedback["error"].present?
            self.get_seller_feedback! box
          end
        #end
      end
    end

    #helper
    def meli_item
       feedback =  Mercadolibre::Feedback.where(meli_order_id: meli_order_id, author_type: "buyer").first
       meli_item_id = feedback.meli_item_id
       item = Mercadolibre::Item.where(meli_item_id: meli_item_id).first
    end

    def box meli_order_id
      box = ::Box.find_by(meli_order_id: meli_order_id)
    end

  end

end
