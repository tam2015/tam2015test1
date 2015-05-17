module Mercadolibre
  class QuestionWorker
    include Sidekiq::Worker
    sidekiq_options queue: :orders, retry: true, backtrace: true

    def perform(user_id, item_id = [], question_id = nil)
      puts "\n\n* Mercadolibre::QuestionWorker.perform - meli_user_id: #{user_id}, item_id: #{item_id}, question_id: #{question_id}\n"

      # Rescue Dashboard
      dashboard = ::Dashboard.includes(:user).find_by(meli_user_id: user_id)
      raise ArgumentError, "Invalid dashboard element.\n meli_user_id=`#{user_id}`\n dashboard=`#{dashboard.inspect}`." unless dashboard.is_a?(::Dashboard)

      if item_id
        # Fetch Item fom Meli
        refresh_token = dashboard.credentials[:refresh_token]
        Mercadolibre::Question.api.update_token(refresh_token)
        meli_questions  = Meli::Question.find_by_item_id(item_id)
        Mercadolibre::Question.perform_async

        # Create Questions
        unless meli_questions.questions.empty?
          Mercadolibre::Question.create_or_update_record(meli_questions.questions, dashboard)
        end
      end

      if question_id
        # Fetch Item fom Meli
        question = []


        refresh_token = dashboard.credentials[:refresh_token]
        Mercadolibre::Question.api.update_token(refresh_token)
        meli_question = Mercadolibre::Question.api.get_question question_id
        
        # used to destroy questions that are removed by Mercado Livre
        if meli_question.status == 404 or meli_question.status == 400
          q = Mercadolibre::Question.find_by(meli_question_id: question_id)
          if q
            q.destroy
          end
        end          
        # meli_question  = Meli::Question.find question_id
        if meli_question
          question << meli_question
        end

        # Create Question
        unless question.empty?
          Mercadolibre::Question.create_or_update_record(question, dashboard)
        end
      end
    end

  end
end
