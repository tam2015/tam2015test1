class Mercadolibre::FeedbacksController < ApplicationController
  require 'will_paginate/array'
  respond_to :html, :json, :js

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]


  def index
    if current_user.admin?
      index_admin
    elsif current_user.regular?
      index_regular
    end
  end

  def index_regular
    if params[:rating_received]
      @feedbacks = Mercadolibre::Feedback.where(dashboard_id: current_user.dashboards.first.id, author_type: "buyer", rating: params[:rating_received]).paginate(page: params[:page], per_page: 7)
    elsif params[:rating_sent]
      @feedbacks = Mercadolibre::Feedback.where(dashboard_id: current_user.dashboards.first.id, author_type: "seller", rating: params[:rating_sent]).paginate(page: params[:page], per_page: 7)
    elsif params[:query]
      @feedbacks = Mercadolibre::Feedback.where(dashboard_id: current_user.dashboards.first.id, meli_order_id: params[:query], author_type: "buyer").paginate(page: params[:page], per_page: 7)
    else
      @feedbacks = Mercadolibre::Feedback.where(dashboard_id: current_user.dashboards.first.id, author_type: "buyer").paginate(page: params[:page], per_page: 7)
      if @feedbacks.count < 1
        redirect_to dashboards_path
        flash[:error] = "Estamos carregando suas qualificações recebidas. Por favor aguarde um momento"
      end
    end
  end

  def index_admin
    if current_user.admin?
      @feedbacks = Mercadolibre::Feedback.where(author_type: "buyer").paginate(page: params[:page], per_page: 7)
    end
  end

  def new
    @feedback = Mercadolibre::Feedback.new
  end

  def create
    order_id = params[:mercadolibre_feedback][:meli_order_id]
    feedback_data = {
      rating: params[:mercadolibre_feedback][:rating],
      fulfilled: true,
      message: params[:mercadolibre_feedback][:message]
    }
    @send_feedback_to_meli = Mercadolibre::Feedback.post_seller_feedback_from_form(current_dashboard.id, order_id, feedback_data)
    if @send_feedback_to_meli #and @send_feedback_to_meli["status"] != 400
       @feedback = Mercadolibre::Feedback.where(meli_order_id: params[:mercadolibre_feedback][:meli_order_id], author_type: "seller").first
       @feedback.update(mercadolibre_feedback_params)
       flash[:success] = "Qualificação enviada com sucesso."
       redirect_to dashboard_feedbacks_path, method: :get
     else
       flash[:error] = "Não foi possível enviar a qualificação."
       redirect_to dashboard_feedbacks_path, method: :get
    end
  end


  def edit
    @feedback = Mercadolibre::Feedback.where(meli_order_id: params[:meli_order_id], author_type: params[:author_type]).first
  end

  def update
    dashboard = Dashboard.find params[:dashboard_id]

    kind = "seller"
    order_id = params[:mercadolibre_feedback][:meli_order_id]
    feedback_data = {
      rating: params[:mercadolibre_feedback][:rating],
      fulfilled: true,
      message: params[:mercadolibre_feedback][:message]
    }
    
    @meli_updated_feedback = Mercadolibre::Feedback.meli_update(order_id, kind, feedback_data, dashboard)
    if @meli_updated_feedback #and @meli_updated_feedback["status"] != 400
       @feedback = Mercadolibre::Feedback.where(meli_order_id: params[:mercadolibre_feedback][:meli_order_id], author_type: "seller").first
       @feedback.update(mercadolibre_feedback_params)
       flash[:success] = "Qualificação editada com sucesso."
       redirect_to dashboard_feedbacks_path, method: :get
     else
       flash[:error] = "Não foi possível editar a qualificação."
       redirect_to dashboard_feedbacks_path, method: :get
    end
  end

  private

    def mercadolibre_feedback_params
      params.require(:mercadolibre_feedback).permit(:rating, :message, :order_id, :dashboard_id, :author_type, :status, :fulfilled, :updated, :reason, :meli_order_id)
    end

end
