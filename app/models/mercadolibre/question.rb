module Mercadolibre
  class Question < ActiveRecord::Base
    include Provider::ModelBase
    serialize :answer

    default_scope  { order(:meli_question_id => :desc) }
    # Question status. Possible values:
      # unanswered: Question is not answered yet.
      # answered: Question was answered.
      # closed_unanswered: The item is closed and the question was never answered.
      # under_review:  The item is under review and the question too.
    enum status: [ :unanswered, :answered, :closed_unanswered, :under_review ]

    # field :item_id

    alias_attribute :date_created, :created_at

    # default_scope -> { order(:status.desc).order(:updated_at.desc) }

    def user
      User.find(user_id) if user_id
    end

    def meli_item
      item_id = meli_item_id
      item = Mercadolibre::Item.find_by(meli_item_id: item_id)
    end

    def customer
      meli_customer_id = author_id
      customer = Customer.find_by(meli_user_id: meli_customer_id)
    end

    def self.text_search(query)
      if query.present?
        where(meli_item_id: query)
      else
        scoped
      end
    end

    def self.unanswered_questions_count
      @number_of_unanswered_questions = self.where(status: :unanswered).count
    end


    def self.create_or_update_record(meli_item_questions = [], dashboard)
      meli_item_questions.map do |meli_item_question|
        if meli_item_question.status != 404
          question                        = Mercadolibre::Question.find_or_create_by(meli_question_id: meli_item_question.id)

          question.dashboard_id           = dashboard.id
          question.user_id                = dashboard.users.first.id

          #user this line to Meli
          # question.author_id              = meli_item_question.from.id

          #user this line to old gem
          question.author_id              = meli_item_question.user_id

          question.seller_id              = meli_item_question.seller_id

          question.meli_date_created      = meli_item_question.date_created.to_date.to_s if meli_item_question.date_created
          question.meli_item_id           = meli_item_question.item_id
          question.text                   = meli_item_question.text
          question.meli_question_id       = meli_item_question.id
          question.deleted_from_listing   = meli_item_question.deleted_from_listing
          question.status                 = meli_item_question.status.downcase
          question.hold                   = meli_item_question.hold
          unless meli_item_question.answer.nil?
            question.answer                 = {
              text:                     meli_item_question.answer.text.to_s,
              # status:                   meli_item_question.status.downcase,
              date_created:             Time.now.to_s
            }
          end

          # we store if Question is new to
          # notify user later on
          new_question = question.new_record?

          # save Question and fetch meli_customer associated to the question
          question.save

            #customer = Mercadolibre::CustomerWorker.perform_async(question.seller_id, question.author_id)
          customer = ::Customer.get_customer(question.seller_id, question.author_id)

          unless Mercadolibre::Item.find_by(meli_item_id: question.meli_item_id)
            ::Mercadolibre::ItemWorker.perform_async question.seller_id, question.meli_item_id
          end

          if question.text.include?("cep") or question.text.include?("CEP") or question.text.include?("Cep") or question.text.include?("Frete") or question.text.include?("frete") or question.text.include?("FRETE")
            item = Mercadolibre::Item.find_by(meli_item_id: question.meli_item_id)            
            # customer_zip_code = question.text.gsub(/[^0-9]/, '')
            # customer_zip_code = question.text.partition('cep').last[0..8].delete(' ,-') if question.text.partition('cep').last[0..8].delete(' ,-,:') != ""
            customer_zip_code = question.text..scan(/\d+.\d+.\d+/).map{ |s| s.gsub(/\D+/, '') }[0]
            seller_zip_code   = item.meli_info.seller_address["zip_code"]#dashboard.preferences.seller_address["zip_code"]
            if item.meli_info.shipping and item.meli_info.shipping["dimensions"] != nil
              dimension = item.meli_info.shipping["dimensions"] || "15x15x25,500"
            else
              # category = item.category_id
              # dimension = Meli::Category.find category
              dimension = "15x15x25,500"
            end
            puts "\n\n\n\n\n---------customer_zip_code#{customer_zip_code}-----------\n\n\n\n\n\n "
            puts "\n\n\n\n\n---------seller_zip_code#{seller_zip_code}-----------\n\n\n\n\n\n "
            puts "\n\n\n\n\n---------dimension#{dimension}-----------\n\n\n\n\n\n "
            costs = Meli::Trend.shipping_calculator(seller_zip_code, customer_zip_code, dimension)
            if costs 
              question.shipping_answer = "O frete via pac custa R$#{costs.options.first.cost} e via Sedex custa R$#{costs.options.last.cost}" 
              question.save
            end
          end

          refresh_token = dashboard.credentials[:refresh_token]
          Mercadolibre::Question.api.update_token(refresh_token)
          question_worker = Mercadolibre::QuestionWorker.perform_in(10.minutes, dashboard.meli_user_id, item_id = [],question.meli_question_id)
        
        end
      end
    end

    def self.find_on_meli id, dashboard
      dashboard = ::Dashboard.find_by(meli_user_id: dashboard.meli_user_id)
      question_ml = self.api.get_question id
    end

    # Post question
    def self.post(question_id, text, dashboard)
      refresh_token = dashboard.credentials[:refresh_token]
      Mercadolibre::Question.api.update_token(refresh_token)
       response_from_meli = Meli::Question.answer_question(question_id, text)
       if response_from_meli.status != 404
         question = Mercadolibre::Question.find_by(meli_question_id: question_id)
         question.update(
           answer:{
            text:                response_from_meli.answer.text.to_s,
            status:              response_from_meli.answer.status.to_s,
            date_created:        response_from_meli.answer.date_created.to_s
         },
           status:               response_from_meli.status.downcase
         )
         question
         #Mercadolibre::Workers::QuestionWorker.perform_async dashboard.uid, question_id #if is_new_record
       end
     end

    def self.delete(question_id)
      @question = self.api.delete_question(question_id)
    end

    def self.meli_block_customer(seller_id, user_id)
      @customer = Meli::Question.add_user_to_blacklist(seller_id, user_id)
    end

    def self.meli_unblock_customer(seller_id, user_id)
      @customer = Meli::Question.remove_user_from_blacklist(seller_id, user_id)
    end


  end
end
