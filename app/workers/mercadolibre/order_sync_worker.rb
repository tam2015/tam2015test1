module Mercadolibre
  class OrderSyncWorker
    include Sidekiq::Worker
    sidekiq_options queue: :orders, retry: true, backtrace: true

    def perform(dashboard_id, kind)
      puts "\n# OrderSyncWorker.initialize - dashboard_id: #{dashboard_id}"

      # rescue Dashboard
      dashboard  = ::Dashboard.includes(:account, :users).find(dashboard_id)
      dashboard.load_provider

      unless dashboard and dashboard.is_a?(::Dashboard)
        raise ArgumentError, "Invalid dashboard ID: dashboard=`#{dashboard_id}`."
      end

      ::Mercadolibre::AccountSync.new(dashboard_id, kind: kind).sync_account!
    end
  end
end
