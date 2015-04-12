module Mercadolibre
  class OrderWorker
    include Sidekiq::Worker
    sidekiq_options queue: :orders, retry: true, backtrace: true

    def perform(user_id, meli_order_id)

      puts "* Mercadolibre::OrderWorker.perform!\n"

      dashboard = ::Dashboard.includes(:account, :users).find_by(meli_user_id: user_id)
      raise ArgumentError, "Invalid dashboard element.\n meli_user_id=`#{user_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)


      #meli_order = ::Box.api.get_order(meli_order_id)
      refresh_token = dashboard.credentials[:refresh_token]
      ::Box.api.update_token(refresh_token)
      meli_order = Meli::Order.find(meli_order_id)


      box = ::Box.find_or_create_by(meli_order_id: meli_order.id)
      box.create_or_update_order(dashboard, meli_order, box)

      # ::Box.new.create_or_update_order(dashboard, meli_order)
    end

  end
end
