module Mercadolibre
  module Hooks

    class Items
      include ActiveModel::Model
      attr_accessor :id, :application_id, :resource, :user_id, :topic, :attempts,
                    :sent, :received

      def initialize(attributes={})
        Rails.logger.info "### Mercadolibre::Hook::Items Initialized"
        super
        @id ||= @resource.gsub(/\/items\//, "")
      end

      def queue_notification
        ::Mercadolibre::ItemWorker.perform_async(self.user_id, self.id)
      end
    end
  end
end

