class BoxesController < ApplicationController
  require 'will_paginate/array'

  before_action :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :json, :js

  # Callbacks
  before_action :paginate_params, only: [ :index ]

  before_action :set_box        , only: [ :show, :edit, :update, :destroy, :status ]

  # DashboardsHelper callback
  before_action :set_dashboard  , only: [ :index, :show, :edit, :update, :status,:index_test]

  before_action :reload_buyer, only: [:show]

  before_action :set_before_params, only: [ :status ]


  # Breadcrumbs
  # add_breadcrumb :index, :dashboard_path
  before_action only: [ :show, :edit ] do
    add_breadcrumb (@dashboard.name || :index ), dashboard_path(@dashboard)
    add_breadcrumb (@box.name       || @box.id), dashboard_box_path(@dashboard, @box)
  end

  def index_test
    if current_user.admin?
      Mercadolibre::Question.all.each do |question|
        meli_question = Meli::Question.find question.meli_question_id
        if meli_question.author_id
          puts "Pergunta existente"
        else
          q = Mercadolibre::Question.find_by(question_meli_id: question.meli_question_id)
          q.destroy
        end
      end
      index_test_franquiador_admin
    elsif current_user.regular?
      index_test_franquiador
    elsif current_user.lojista?
      index_test_lojista
    end
  end

  def show
    @customer = @box.customer || @box.customer.build
    @feedback = @box.feedback #|| @box.feedback.build
  end

  def new
    @box = current_user.boxes.new
  end

  def edit
    @customer = @box.customer
    @box = Box.find params[:id]
  end

  def create
    @box = Box.new(box_params)
    @box.account_id = current_user.account_id

    flash[:notice] = 'Box was successfully created.' if @box.save
    respond_with @box
  end

  def update
    # if @dashboard and @dashboard.provider?
    #   Rails.logger.debug "\n\n"
    #   Rails.logger.debug " ======== Box.update#status"

    #   box_params.slice(:status).each do |key, value|
    #     @box.send("#{key}=", value) if @box.respond_to? key
    #   end
    #   Rails.logger.debug " =========== box.changes: #{@box.changes}"

    #   if @box.changed?
    #     provider_of_box = "#{@dashboard.provider}::Box".classify.constantize.new @dashboard
    #     @box = provider_of_box.post @box
    #   end

    #   box_params.each do |key, value|
    #     @box.send("#{key}=", value) if @box.respond_to? key
    #   end

    #   Rails.logger.debug "-------------------------"
    #   Rails.logger.debug " =========== api posted: #{@box.inspect}"
    #   Rails.logger.debug " =========== api errors: #{@box.errors.to_json}"
    #   Rails.logger.debug "\n\n"
    # end

    # @box.save if @box.errors.empty? and @box.changed?

    # if !@box.errors.empty?
    #   @box.errors.each do |code, message|
    #     flash[:error] = message
    #   end
    # else
    #   flash[:success] = 'Box was successfully updated.'
    # end

    # respond_with @box
    @box = Box.find params[:id]
    if @box.update(box_params)
      redirect_to dashboard_index_test_path
    else
      redirect_to dashboard_index_test_path
    end
  end



  # DELETE /boxes/1
  # DELETE /boxes/1.json
  def destroy
    # Remove comments to use Paranoia
    # if @force = params[:force]
      flash[:error] = "Box was successfully destroyed."
      @box.destroy!
    # else
    #   flash[:alert] = "Box was successfully deleted."
    #   @box.destroy
    # end
  end

  # Others Controllers
  #######################

  # dashboard_box_status POST     /d/:dashboard_id/:box_id/status(.:format)
  def status
    # @box.status   = box_params[:status]
    # @old_position = params[:box] ? params[:box][:old_position] : 0
    @update_params = params[:box] || {}

    # respond_with @box, location: dashboard_box_path(@dashboard, @box)
    respond_with [@dashboard, @box]
  end

  def reload_buyer
    #dashboard_id = Dashboard.find params[:dashboard_id]
    box = Box.find(params[:id])
    order_id = box.meli_order_id
    Rails.logger.debug " \n\n\n\n\n\n\n\n\n-------------------order_id #{order_id}"
    unless Meli::Base.oauth_connection.expired?
      @feedback = Mercadolibre::Feedback.get! order_id, dashboard_id: params[:dashboard_id]
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_box
      @box = Box.find(params[:box_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def box_params
      params.require(:box).permit(:name, :description, :position, :closed, :price, :status, :favorite, :tags, :manual_variation, 
        # Providers
        :meli_order_id,
        # Assosiations
        :account_id, :customer_id, :dashboard_id, :user_id)
    end

    def paginate_params
      {
        page:     (params[:page ] || 1),
        per_page: (params[:limit] || params[:per_page] || 100)
      }
    end


    def index_test_franquiador

    #address_status_filter
      if params[:status_address]
        @boxes = current_user.dashboards.first.boxes.includes(:payments,:shipping, :customer).where(shippings: {pendings_status: params[:status_address]}).paginate(page: params[:page], per_page: 5)

      elsif params[:status_data]
        @boxes = current_user.dashboards.first.boxes.includes(:payments,:shipping, :customer).where(customers: { pendings_status: params[:status_data]}).paginate(page: params[:page], per_page: 5)

      #payment_status_filter
      elsif params[:status_box_payment]
        @boxes = current_user.dashboards.first.boxes.where("tags && ARRAY['#{params[:status_box_payment]}']::character varying(255)[]").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)

      #shipping_status_filter
      elsif params[:status_box_shipping]
        @boxes = current_user.dashboards.first.boxes.where("tags && ARRAY['#{params[:status_box_shipping]}']::character varying(255)[]").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      # elsif params[:status_box]
      #   @boxes = @dashboard.boxes.where("'rails' = ALL(tags)").paginate(page: params[:page], per_page: 5)

      elsif params[:query]
        if current_user.dashboards.first.boxes.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
          @boxes = current_user.dashboards.first.boxes.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
        elsif current_user.customers.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
          @boxes = current_user.customers.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
        elsif current_user.customers.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
          @boxes = current_user.customers.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
        end

      else
        @boxes = current_user.dashboards.first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
        if @boxes.count < 1
          redirect_to dashboards_path
          flash[:error] = "Estamos carregando suas vendas. Por favor aguarde um momento"
        end
      end
    end

    def index_test_franquiador_admin

    #address_status_filter
      if params[:status_address]
        @boxes = Box.all.joins(:shipping).where(shippings: {pendings_status: params[:status_address]}).paginate(page: params[:page], per_page: 5)

      elsif params[:status_data]
        @boxes = Box.all.includes(:customer).where(customers: { pendings_status: params[:status_data]}).paginate(page: params[:page], per_page: 5)

      #payment_status_filter
      elsif params[:status_box_payment]
        @boxes = Box.all.where("tags && ARRAY['#{params[:status_box_payment]}']::character varying(255)[]").includes(:shipping, :payments).paginate(page: params[:page], per_page: 5)

      #shipping_status_filter
      elsif params[:status_box_shipping]
        @boxes = Box.all.where("tags && ARRAY['#{params[:status_box_shipping]}']::character varying(255)[]").includes(:shipping, :payments).paginate(page: params[:page], per_page: 5)
      # elsif params[:status_box]
      #   @boxes = @dashboard.boxes.where("'rails' = ALL(tags)").paginate(page: params[:page], per_page: 5)

      elsif params[:query]
        if Box.all.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:customer).paginate(page: params[:page], per_page: 5).count > 0
          @boxes = Box.all.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:customer).paginate(page: params[:page], per_page: 5)
        elsif Customer.where(email: params[:query]).first and Customer.where(email: params[:query]).first.boxes.paginate(page: params[:page], per_page: 5).count > 0
          @boxes = Customer.where(email: params[:query]).first.boxes.paginate(page: params[:page], per_page: 5)
        elsif Customer.where(nickname: params[:query]).first and Customer.where(nickname: params[:query]).first.boxes.paginate(page: params[:page], per_page: 5).count > 0
          @boxes = Customer.where(nickname: params[:query]).first.boxes.paginate(page: params[:page], per_page: 5)
        else
          #temporary solution
          @boxes = Box.all.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:customer).paginate(page: params[:page], per_page: 5)
          flash[:error] = "Não foi possível encontrar nenhuma venda nessa busca"
        end

      else
        @boxes = Box.all.includes(:shipping).paginate(page: params[:page], per_page: 5)
        if @boxes.count < 1
          redirect_to dashboards_path
          flash[:error] = "Estamos carregando suas vendas. Por favor aguarde um momento"
        end
      end
    end
      #testing box_tag_filter
      #@boxes = Box.array_has_any(:tags, params[:status_box][0], params[:status_box][1]).paginate(page: params[:page], per_page: 5) if params[:status_box]
      #@boxes = Box.where(" tags && ARRAY['paid', 'not_delivered']::character varying(255)[]")

    #Used by "franquiador" business
    def index_test_lojista params
      @boxes = @dashboard.boxes.where(user: current_user).paginate(page: params[:page], per_page: 2)
    end


end
