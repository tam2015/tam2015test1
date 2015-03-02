class Mercadolibre::FeedbacksController < ApplicationController
  require 'will_paginate/array'
  respond_to :html, :json, :js

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]


  def index
    if params[:rating_received]
      @buyer_feedbacks = Mercadolibre::Feedback.where(dashboard_id: @dashboard.id, author_type: "buyer", rating: params[:rating_received]).paginate(page: params[:page], per_page: 7)
    elsif params[:rating_sent]
      @buyer_feedbacks = Mercadolibre::Feedback.where(dashboard_id: @dashboard.id, author_type: "seller", rating: params[:rating_sent]).paginate(page: params[:page], per_page: 7)
    else
      @buyer_feedbacks = Mercadolibre::Feedback.where(dashboard_id: @dashboard.id, author_type: "buyer").paginate(page: params[:page], per_page: 7)
      if @buyer_feedbacks.count < 1
        redirect_to dashboards_path
        flash[:error] = "Estamos carregando suas qualificações recebidas. Por favor aguarde um momento"
      end
    end
  end

  def new
    @feedback = Mercadolibre::Feedback.new
  end

  def create

    @feedback = Mercadolibre::Feedback.create(feedback_params)

    order_id = @feedback.meli_order_id
      Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------order_id(thiago) #{order_id}"

    feedback_data = {
      rating: @feedback.rating,
      fulfilled: true,
      message: @feedback.message
    }

    @ml_seller_feedback = Mercadolibre::Feedback.post(order_id, feedback_data)

  end

  def edit
    @feedback = Mercadolibre::Feedback.where(meli_order_id: params[:meli_order_id], author_type: params[:author_type]).first
  end

  def update
    @feedback = Mercadolibre::Feedback.where(meli_order_id: feedback_params[:meli_order_id], author_type: "seller").first
    @feedback.update(feedback_params)
    Rails.logger.debug "\n\n\n\n\n\n\n\n\n\n  ---- #{@feedback.to_json}"

    order_id = @feedback.meli_order_id
    kind = @feedback.author_type
    feedback_data = {
      rating: @feedback.rating,
      fulfilled: true,
      message: @feedback.message
    }
    @meli_updated_feedback = Mercadolibre::Feedback.meli_update(order_id, kind, feedback_data)
  end

  private

    def feedback_params
      params.require(:mercadolibre_feedback).permit(:rating, :message, :order_id, :dashboard_id, :author_type, :status, :fulfilled, :updated, :reason)
    end

end
