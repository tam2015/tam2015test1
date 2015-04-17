module Mercadolibre
  class QuestionSyncWorker
    include Sidekiq::Worker
    sidekiq_options queue: :sync_questions, retry: true, backtrace: true

    def perform(dashboard_id)
      puts "\n# QuestionSyncWorker.initialize - dashboard_id: #{dashboard_id}"

      # rescue Dashboard
      dashboard  = ::Dashboard.includes(:account, :users).find(dashboard_id)
      dashboard.load_provider

      meli_questions = []
      unless dashboard and dashboard.is_a?(::Dashboard)
        raise ArgumentError, "Invalid dashboard ID: dashboard=`#{dashboard_id}`."
      end

      # meli_questions = Meli::Question.all_questions
      filters = {limit: 80, offset: 50}
      refresh_token = dashboard.credentials[:refresh_token]
      Mercadolibre::Question.api.update_token(refresh_token)
      meli_questions = Mercadolibre::Question.api.get_all_questions filters
      Mercadolibre::Question.create_or_update_record(meli_questions, dashboard)
    end

  end
end
