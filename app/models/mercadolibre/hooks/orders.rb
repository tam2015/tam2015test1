module Mercadolibre
  module Hooks

    class Orders
      include ActiveModel::Model
      attr_accessor :id, :application_id, :resource, :user_id, :topic, :attempts,
                    :sent, :received

      def initialize(attributes={})
        Rails.logger.info "### Mercadolibre::Hook::Orders Initialized"
        super
        @id ||= @resource.gsub(/\/orders\//, "")
      end

      def queue_notification
        ::Mercadolibre::OrderWorker.perform_async(self.user_id, self.id)
      end
    end

  end
end
