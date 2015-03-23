module Mercadolibre
  class ShippingWorker
    include Sidekiq::Worker
    sidekiq_options queue: :orders, retry: true, backtrace: true

    def perform(dashboard_id, order_id, box_id)
      puts "\n\n* Mercadolibre::ShippingWorker.perform!\n"

      dashboard = ::Dashboard.find_by(id: dashboard_id)
      raise ArgumentError, "Invalid dashboard element.\n dashboard_id=`#{dashboard_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)

      box             = ::Box.find(box_id)
      shipping        = ::Mercadolibre::Shipping.find_or_initialize_by(meli_order_id: order_id)
      shipping_hash   = Meli::Shipment.find_by_order_id order_id

      puts "\n\nShipping Hash: #{shipping_hash.inspect}\n\n"

      shipping.meli_shipping_id    = shipping_hash.id
      shipping.shipping_mode       = shipping_hash.mode
      # tracking
      shipping.tracking_number     = shipping_hash.tracking_number
      shipping.tracking_method     = shipping_hash.tracking_method
      shipping.status              = shipping_hash.status

      # label infos
      #sender_address:       shipping_hash.sender_address,
      shipping.receiver_address    = shipping_hash.serializable_hash[:receiver_address] if !shipping_hash.receiver_address.nil? and shipping.updated_by_seller == false and shipping.updated_by_customer == false
      # Associations
      shipping.dashboard_id        = box.dashboard.id
      shipping.meli_order_id       = box.meli_order_id.to_s
      shipping.accept_mercadoenvios= true
      shipping.date_shipped        = shipping_hash.status_history.date_shipped
      shipping.date_delivered      = shipping_hash.status_history.date_delivered

      shipping.save
    end
  end
end
