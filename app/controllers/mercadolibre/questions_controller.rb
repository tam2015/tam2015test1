class Mercadolibre::QuestionsController < ApplicationController
  require 'will_paginate/array'

  before_action :authenticate_user!

  respond_to :html, :js, :json

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index, :reload]
  load_and_authorize_resource


  def index

    #render the details of a catalog item
    if params[:meli_item_id] && params[:class]
      #@item = Mercadolibre::Item.find(params[:item_id])
      @item = Mercadolibre::Item.find(params[:meli_item_id])
      Rails.logger.debug " \n\n\n\n\n #{@item.to_json}"
      if @item
        render "question_details"
      end

  #to filter a question
    elsif params[:status]
      @questions = Mercadolibre::Question.where(status: params[:status].to_sym, dashboard_id: current_user.dashboards.first.id).paginate(page: params[:page], per_page: 5)

  #to search a question
    elsif params[:query]
      @dashboard_questions = Mercadolibre::Question.where(dashboard_id: current_dashboard.id)
      @questions = @dashboard_questions.where("meli_item_id ilike :q or text ilike :q", q: "%#{params[:query]}%").paginate(page: params[:page], per_page: 5)

    elsif params[:author_id] and params[:meli_item_id]
      @questions = Mercadolibre::Question.where(dashboard_id: current_dashboard.id, author_id: params[:author_id], meli_item_id: params[:meli_item_id]).paginate(page: params[:page], per_page: 5)

    else
      @questions = Mercadolibre::Question.where(dashboard_id: current_user.dashboards.first.id).paginate(page: params[:page], per_page: 5)
      if @questions.count < 1
        redirect_to dashboards_path
        flash[:error] = "Estamos carregando suas perguntas. Por favor aguarde um momento"
      end
    end
  end


  def reload
    @questions = Mercadolibre::Question.get!({
      dashboard: @dashboard
    })

    respond_with @questions, url: dashboard_questions_path
  end


  def edit
    #Rails.logger.debug "\n\n\n\n\n\n\n\n\n\n  ---- #{params[:id]} (#{params[:id].class})"
    @question = Mercadolibre::Question.find(params[:id])#, user_id: current_user.id).first
  end

  def update
    @question = Mercadolibre::Question.find(question_params[:id])#, user_id: current_user.id).first
    #Rails.logger.debug "\n\n\n\n\n\n\n\n\n\n  ---- #{@question.to_json}"
    #Rails.logger.debug "\n\n\n\n\n\n\n\n\n\n  ---- #{question_params}"
    #Rails.logger.debug "\n\n\n\n\n\n\n\n\n\n  ---- #{question_params["id"]}"
    #Rails.logger.debug "\n\n\n\n\n\n\n\n\n\n  ---- #{question_params[:id]}"

    # answer = Mercadolibre::Answer.new({
    #   text: answer_text,
    #   status: "ACTIVE",
    #   date_created: Time.current.to_json
    # })

    update_params = {
      status: :answered,
      dashboard_id: current_dashboard.id,
      answer: question_params[:answer].to_h
      }

    # if params[:mercadolibre_question][:answer][:accepts] == true
    #   CannedResponse.create(text: update_params[:answer]["text"], dashboard_id: current_dashboard.id)
    # end
      # }.merge( question_params.to_h )
    # update_params[:answer].merge({ status: "ACTIVE" })

    Rails.logger.debug " \n\n\n\n\n #{update_params}"
    Rails.logger.debug " \n ---- #{question_params.to_h}"
    Rails.logger.debug " \n (#{update_params[:answer].class}) #{update_params[:answer].class}"
    Rails.logger.debug " \n Question.post #{@question.id}, #{update_params[:answer]["text"]}"


    # FIXME: Caso seja retornado algum erro na API deve mudar o status do item e
    #   impedir que esse status seja sobreposto pelo do ML
    @ml_answer = Mercadolibre::Question.post(@question.meli_question_id, update_params[:answer]["text"], current_dashboard)


    if @ml_answer[:text].present?
      redirect_to dashboard_questions_path
      flash[:success] = "Resposta enviada."
    else
      redirect_to dashboard_questions_path
      flash[:error] = "Não foi possível enviar sua resposta. Por favor fale com nossa equipe."
    end
    # saved = @question.update({"answer"=>{"text"=>"resposta pergunta 30"}, "status"=>"answered", "dashboard_id"=>5})
    # Rails.logger.debug " \n\n\n\n\n saved? = #{saved} #{@question.errors.to_json}"
    # Rails.logger.debug " \n #{update_params}"
    # Rails.logger.debug " \n #{@question.to_json}"


    #respond_with @question
  end

  def destroy
    @question = Mercadolibre::Question.find(params[:id].to_i)
    question_id = @question.id

    @destroyed_ml_question = Mercadolibre::Question.delete(question_id)
    if @destroyed_ml_question
      @question.destroy
    else
      # error message
    end
  end

  def block_customer
    @question = Mercadolibre::Question.find(params[:question_id])
    @questions = Mercadolibre::Question.where(author_id: @question.author_id)
    @customer = Customer.where(meli_user_id: @question.author_id).first
    user_id = @question.author_id
    seller_id =  @question.seller_id
    @blocked_customer = Mercadolibre::Question.meli_block_customer(seller_id, user_id)
    if @blocked_customer
      @customer.update(blocked: true)
      @question.update(customer_blocked: true)
      @questions.each do |question|
        question.update(customer_blocked: true)
      end
      redirect_to dashboard_questions_path
      flash[:success] = "Usuário bloqueado com sucesso."
    else
      redirect_to dashboard_questions_path
      flash[:error] = "Não foi possível bloquear o usuário"
    end
  end

  def unblock_customer
    @question = Mercadolibre::Question.find(params[:question_id])
    @questions = Mercadolibre::Question.where(author_id: @question.author_id)
    @customer = Customer.where(meli_user_id: @question.author_id).first
    user_id = @question.author_id
    seller_id =  @question.seller_id
    @unblocked_customer = Mercadolibre::Question.meli_unblock_customer(seller_id, user_id)
    if @unblocked_customer
      @customer.update(blocked: false)
      @question.update(customer_blocked: false)
      @questions.each do |question|
        question.update(customer_blocked: false)
      end
      redirect_to dashboard_questions_path
      flash[:success] = "Usuário desbloqueado com sucesso."
    else
      redirect_to dashboard_questions_path
      flash[:error] = "Não foi possível desbloquear o usuário"
    end
  end



#  def post_answer
#    question_id = params[:question_id]
#    text        = params[:text]
#    @answer     = Question.answer_question(question_id, text)


  private

    def question_params
      answer_params = [ :text ]
      params.require(:mercadolibre_question).permit(:id, answer: answer_params)
    end


end
