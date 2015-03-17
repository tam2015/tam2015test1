module Mercadolibre
  class OrderWorker
    include Sidekiq::Worker
    sidekiq_options queue: :orders, retry: true, backtrace: true

    def perform(user_id, meli_order_id)

      puts "* Mercadolibre::OrderWorker.perform!\n"

      dashboard = ::Dashboard.includes(:account, :users).find_by(meli_user_id: user_id)
      raise ArgumentError, "Invalid dashboard element.\n meli_user_id=`#{user_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)

      meli_order = Meli::Order.find(meli_order_id)

      ::Box.new.create_or_update_order(dashboard, meli_order)
    end

  end
end
