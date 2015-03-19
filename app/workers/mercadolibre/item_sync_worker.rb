module Mercadolibre
  class ItemSyncWorker
    include Sidekiq::Worker
    sidekiq_options queue: :sync_items, retry: true, backtrace: true

    def perform(dashboard_id)
      puts "\n# ItemSyncWorker.initialize - dashboard_id: #{dashboard_id}"

      # rescue Dashboard
      dashboard  = ::Dashboard.includes(:account, :users).find(dashboard_id)
      dashboard.load_provider

      meli_item_ids = []
      unless dashboard and dashboard.is_a?(::Dashboard)
        raise ArgumentError, "Invalid dashboard ID: dashboard=`#{dashboard_id}`."
      end

      ids = Mercadolibre::Item.api.get_my_item_ids
      meli_item_ids = ids[:results]
      meli_item_ids.map do |meli_item_id|
        # Fire another worker to handle API request
        Mercadolibre::ItemWorker.perform_async dashboard.meli_user_id, meli_item_id
      end
    end

  end
end
