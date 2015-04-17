module Mercadolibre
  class AccountSyncWorker
    include Sidekiq::Worker
    sidekiq_options queue: :sync_account, retry: true, backtrace: true

    def perform(dashboard_id)
      # Sync Item by Item from User  (Seller)
      ::Mercadolibre::ItemSyncWorker.perform_async dashboard_id

      # Sync Question by Question for User (Seller)
      ::Mercadolibre::QuestionSyncWorker.perform_async dashboard_id

      # Sync Sale by Sale from User  (Seller)
      # TODO: ✔ if anything under AccountSync break,
      #       AccountSyncWorker will repet ItemSyncWorker and QuestionSyncWorker
      #       We should avoid it to happen breaking AccountSync.new to a worker
      #[:recent, :archived].each do |_kind|
      [:recent].each do |_kind|
        ::Mercadolibre::OrderSyncWorker.perform_async dashboard_id, _kind
      end
    end
  end
end
