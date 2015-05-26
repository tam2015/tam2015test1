class Mercadolibre::ReceiptsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource

  # to fix
  add_breadcrumb :index, :dashboards_path

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]


  def index
    if current_user.admin?
      admin_index
    elsif current_user.regular?
      regular_index
    end    
  end

  def regular_index
    if params[:query]
      if current_user.dashboards.first.boxes.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = current_user.dashboards.first.boxes.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      elsif current_user.customers.where(email: params[:query]).count > 0 and current_user.customers.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = current_user.customers.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      elsif current_user.customers.where(nickname: params[:query]).count > 0 and current_user.customers.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = current_user.customers.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      end      
    elsif params[:status_box_payment]
      @payments = Mercadolibre::Payment.where(dashboard_id: current_dashboard.id, status: params[:status_box_payment]).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)                        
    #shipping_status_filter
    elsif params[:status_box_shipping]
      @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id, status: params[:status_box_shipping]).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)                            
    elsif params[:status_feedback] == "com_qualificação"
      feedbacks = Mercadolibre::Feedback.where(author_type: "seller", rating: ["positive", "neutral", "negative"])
      if feedbacks.present?
        meli_order_ids = []
        feedbacks.each do |feedback| 
          meli_order_ids << feedback.meli_order_id
        end
        @boxes = current_user.dashboards.first.boxes.where(meli_order_id: meli_order_ids).includes(:payments,:shipping, :customer).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)            
      end
    elsif params[:status_feedback] == "sem_qualificação"
      feedbacks = Mercadolibre::Feedback.where(author_type: "seller", rating: nil)
      if feedbacks.present?
        meli_order_ids = []
        feedbacks.each do |feedback| 
          meli_order_ids << feedback.meli_order_id
        end
        @boxes = current_user.dashboards.first.boxes.where(meli_order_id: meli_order_ids).includes(:payments,:shipping, :customer).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)            
      # else
      #   @boxes = []
      #   # redirect_to dashboard_box_receipts_path
      end
    else   
      @boxes = current_user.boxes.order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
    end
  end

  def admin_index
    if params[:query]
      if ::Box.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = ::Box.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      elsif ::Customer.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = ::Customer.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      elsif ::Customer.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5).count > 0
        @boxes = ::Customer.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).paginate(page: params[:page], per_page: 5)
      end      
    elsif params[:status_box_payment]
      @payments = Mercadolibre::Payment.where(status: params[:status_box_payment]).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)                  
    #shipping_status_filter
    elsif params[:status_box_shipping]
      @shippings = Mercadolibre::Shipping.where(status: params[:status_box_shipping]).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)                        
    elsif params[:status_feedback] == "com_qualificação"
      feedbacks = Mercadolibre::Feedback.where(author_type: "seller", rating: ["positive", "neutral", "negative"])
      if feedbacks.present?
        meli_order_ids = []
        feedbacks.each do |feedback| 
          meli_order_ids << feedback.meli_order_id
        end
        @boxes = ::Box.where(meli_order_id: meli_order_ids).includes(:payments,:shipping, :customer).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)            
      end
    elsif params[:status_feedback] == "sem_qualificação"
      feedbacks = Mercadolibre::Feedback.where(author_type: "seller", rating: nil)
      if feedbacks.present?
        meli_order_ids = []
        feedbacks.each do |feedback| 
          meli_order_ids << feedback.meli_order_id
        end
        @boxes = ::Box.where(meli_order_id: meli_order_ids).includes(:payments,:shipping, :customer).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)            
      # else
      #   @boxes = []
      #   # redirect_to dashboard_box_receipts_path
      end
    else   
      @boxes = ::Box.order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
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

