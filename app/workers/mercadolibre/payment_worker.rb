module Mercadolibre
  class PaymentWorker
    include Sidekiq::Worker
    sidekiq_options queue: :boxes, retry: true, backtrace: true

    def perform(dashboard_id, payment_id = nil)
      puts "\n\n* Mercadolibre::PaymentWorker.perform!\n"

      # Rescue Dashboard
      dashboard = ::Dashboard.find_by(id: dashboard_id)
      raise ArgumentError, "Invalid dashboard element.\n dashboard_id=`#{dashboard_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)

      if payment_id
        # Fetch Payment fom Meli
        payment  = Meli::Payment.find(payment_id)

        # Update Payment
        Mercadolibre::Item.parse(payment, dashboard)
      end
    end

  end
end
