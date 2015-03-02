module Mercadolibre
  module Hooks
    class Questions
      include ActiveModel::Model
      attr_accessor :id, :application_id, :resource, :user_id, :topic, :attempts,
                    :sent, :received

      def initialize(attributes={})
        Rails.logger.info "### Mercadolibre::Hook::Questions Initialized"
        super
        @id ||= @resource.gsub(/\/questions\//, "")
      end

      def queue_notification
        ::Mercadolibre::QuestionWorker.perform_async(self.user_id, item_id = [], self.id)
      end
    end
  end
end
