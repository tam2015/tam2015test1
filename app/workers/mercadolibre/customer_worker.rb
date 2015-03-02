module Mercadolibre
  class CustomerWorker
    include Sidekiq::Worker
    sidekiq_options queue: :sync_items, retry: true, backtrace: true

    def perform(user_id, customer_id)
      #puts "\n\n* Mercadolibre::ItemWorker.perform - meli_user_id: #{user_id}, item_id: #{item_id}\n"

      # Rescue Dashboard
      dashboard = ::Dashboard.find_by(meli_user_id: user_id)
      raise ArgumentError, "Invalid dashboard element.\n meli_user_id=`#{user_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)

      if user_id and customer_id
        # Fetch Item fom Meli
        meli_customer  = Meli::User.find(customer_id)
        meli_seller = ::Dashboard.find_by(meli_user_id: user_id).users.first

        # Update Item
        ::Customer.parse(meli_customer, meli_seller)

        # Data Collection for post analysis
        #Datastores.create!(from: :meli_item,
        #                  meli_id: meli_item.id,
        #                  klass: meli_item.class,
        #                  json: meli_item.serializable_hash)
      end
    end

  end
end
