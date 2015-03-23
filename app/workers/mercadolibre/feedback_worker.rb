module Mercadolibre
  class FeedbackWorker
    include Sidekiq::Worker
    sidekiq_options queue: :orders, retry: true, backtrace: true

    def perform(worker_type, dashboard_id, meli_order_id = nil)
      puts "\n\n* Mercadolibre::FeedbackWorker.perform! type: #{worker_type}\n"

      dashboard = ::Dashboard.find_by(id: dashboard_id)
      raise ArgumentError, "Invalid dashboard element.\n dashboard_id=`#{dashboard_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)

      case worker_type.to_sym

        when :retrieve_item_feedback
          self.retrieve_item_feedback(dashboard_id, meli_order_id)

        when :post_sale_feedback
          self.post_sale_feedback(dashboard_id, meli_order_id)

        when :post_and_retrieve_feedback
          self.post_sale_feedback(dashboard_id, meli_order_id)
          self.retrieve_item_feedback(dashboard_id, meli_order_id)
        else
          puts "* Unknown Feedback worker_type: #{worker_type}"
          return
      end
    end

    def retrieve_item_feedback(dashboard_id, meli_order_id)
      if meli_order_id
        # Fetch Feedbacks from Meli
        meli_order_feedback  = Meli::Feedback.find_by_order_id(meli_order_id)

        # Update Feedbacks
        Mercadolibre::Feedback.update_record(:retrieve_item_feedback, dashboard_id, meli_order_id, meli_order_feedback)
      end
    end

    def post_sale_feedback(dashboard_id, meli_order_id)
      if meli_order_id
        params = {
          "fulfilled" => true,
          "rating"    => "positive",
          "message"   => "Bom comprador."
        }
        # Post seller Feedback on Meli
        meli_order_feedback  = Meli::Feedback.post_feedback(meli_order_id, params)
        # meli_order_feedback  = Mercadolibre::Feedback.api.give_feedback_to_order(meli_order_id, params)

        puts "\n\n ** Sale Feedback posted: #{meli_order_feedback.inspect}"
        # Update Feedbacks
        Mercadolibre::Feedback.update_record(:post_sale_feedback, dashboard_id, meli_order_id, meli_order_feedback)
      end
    end


    # {"message":"You can't send 'reason' parameter as part of the request when fulfilled is true","error":"bad_request","status":400,"cause":[]}

    # {
    #   # Experience
    #   "rating"    => "neutral",
    #   # Feedback message
    #   "message"   => "Bom comprador."
    #   # Order fulfilled?
    #   "fulfilled" => true,
    #   # Justifies fulfilled=false
    #   "reason"    => ""
    #   # Replies w00t?
    #   "reply"     => ""
    # }

  end
end
