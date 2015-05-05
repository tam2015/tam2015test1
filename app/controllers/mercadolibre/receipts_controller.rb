class Mercadolibre::ReceiptsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource

  # to fix
  add_breadcrumb :index, :dashboards_path

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]


  def index
    if params[:query]
      if current_user.dashboards.first.boxes.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = current_user.dashboards.first.boxes.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      elsif current_user.customers.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = current_user.customers.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      elsif current_user.customers.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = current_user.customers.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      end      
    elsif params[:status_box_payment]
      @boxes = current_user.dashboards.first.boxes.where("tags && ARRAY['#{params[:status_box_payment]}']::character varying(255)[]").includes(:payments,:shipping, :customer).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
    #shipping_status_filter
    elsif params[:status_box_shipping]
      @boxes = current_user.dashboards.first.boxes.where("tags && ARRAY['#{params[:status_box_shipping]}']::character varying(255)[]").includes(:payments,:shipping, :customer).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)      
    elsif params[:status_feedback] == "com_feedback"
      # feedbacks = Mercadolibre::Feedback.where(author_type: "seller", rating: ["positive", "neutral", "negative"])
      # if feedbacks.present?
      #   meli_order_ids = feedbacks.pluck[:meli_order_id]
      #   @boxes = current_user.dashboards.first.boxes.where(meli_order_id: meli_order_ids).includes(:payments,:shipping, :customer).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)            
      # end
      feedbacks = Mercadolibre::Feedback.where(author_type: "seller", rating: ["positive", "neutral", "negative"])
      puts "\n\n\n\n\n\n------ #{feedbacks.pluck[:meli_order_id].inspect}"
    elsif params[:status_feedback] == "sem_feedback"
      @feedbacks = Mercadolibre::Feedback.where(author_type: "seller", rating: nil)
      if @feedbacks.count > 0
        meli_order_ids = @feedbacks.pluck[:meli_order_id]
        @boxes = current_user.dashboards.first.boxes.where(meli_order_id: meli_order_ids).includes(:payments,:shipping, :customer).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)                  
      end
    else   
      @boxes = current_user.boxes.order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
    end
  end

  def show
	@box = ::Box.find params[:box_id]
  render :layout => false
  end

  def mass_receipt
    @boxes = []
    boxes_ids = params[:box_id]
    boxes_ids.each do |box_id|
      box = ::Box.find box_id
      @boxes << box
    end

    @boxes
    render :layout => false
  end

end

