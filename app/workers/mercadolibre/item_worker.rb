module Mercadolibre
  class ItemWorker
    include Sidekiq::Worker
    sidekiq_options queue: :sync_items, retry: true, backtrace: true

    def perform(user_id, item_id)
      puts "\n\n* Mercadolibre::ItemWorker.perform - meli_user_id: #{user_id}, item_id: #{item_id}\n"

      # Rescue Dashboard
      dashboard = ::Dashboard.find_by(meli_user_id: user_id)
      raise ArgumentError, "Invalid dashboard element.\n meli_user_id=`#{user_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)

      if item_id
        # Fetch Item fom Meli
        meli_item  = Meli::Item.find(item_id)

        # Update Item
        Mercadolibre::Item.create_or_update_record(meli_item, dashboard)

        # Data Collection for post analysis
        # Datastores.create!(from: :meli_item,
        #                   meli_id: meli_item.id,
        #                   klass: meli_item.class,
        #                   json: meli_item.serializable_hash)
      end
    end

  end
end
