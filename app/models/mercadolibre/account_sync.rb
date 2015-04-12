module Mercadolibre
  class AccountSync

    # number_to_currency
    include ActionView::Helpers::NumberHelper

    def initialize dashboard_id, *meli_options
      puts "\n# AccountSyncWorker.initialize - dashboard_id: #{dashboard_id}, kind: #{meli_options}"

      # rescue Dashboard
      @dashboard = ::Dashboard.includes(:account, :users).find(dashboard_id)

      unless @dashboard and @dashboard.is_a?(::Dashboard)
        raise ArgumentError, "Invalid dashboard ID: dashboard=`#{dashboard_id}`."
      end

      # config Meli::Orders to fetch boxes
      Meli::Order.options = set_meli_options *meli_options
    end

    def set_meli_options *meli_options
      # Set Seller
      opts = {
        seller: @dashboard.meli_user_id,
        sort: "date_desc"
      }

      meli_options.each {|opt| opts.merge!(opt) if opt.is_a? Hash }

      opts
    end


    def sync_account!
      puts "# AccountSyncWorker.sync_account!"
      # Fetch every Order from Meli
      fetch_meli_boxes!

      # Mark Dashboard as synced
      @dashboard.synced!
    end

    ##
    # TODO
    # Refactor to enqueue partial orders instead of processing
    # all at once because Meli Seller history can be very big.
    # #
    def fetch_meli_boxes!(filters={})
      puts "# AccountSyncWorker.fetch_meli_boxes! filters: #{filters}"
      query_meli_boxes filters do |partial_orders, data, opts|
        puts "# AccountSyncWorker.fetch_meli_boxes! opts: #{opts}"
        add_to_collection partial_orders, opts
        ##
        # TODO
        # Enqueue collection instead of adding to collection
        # enqueue_meli_query opts
        ##
      end
    end

    def filters
      Meli::Order.options
    end

    def filters= options
      Meli::Order.options = options
    end

    def query_meli_boxes(filters={}, &block)
      puts "# AccountSyncWorker.query_meli_boxes..."
      filters.reverse_merge! Meli::Order.options
      Meli::Order.all filters, &block
    end

    # TODO
    # implement a box per worker
    def enqueue_meli_query; end

    def add_to_collection(partial_orders_collection, opts={})
      puts "# AccountSyncWorker.add_to_collection"
      partial_orders_collection.map do |meli_order|


        box = ::Box.where(meli_order_id: meli_order.id).first_or_initialize
        box.create_or_update_order(@dashboard, meli_order, box)
        # ::Box.new.create_or_update_order(@dashboard, meli_order)

        # Data Collection for post analysis
        # Datastores.create!(from: :account_sync_partial_order,
        #                   meli_id: meli_order.id,
        #                   klass: meli_order.class)
      end
    end

  end
end
