class Mercadolibre::LabelController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # to fix
  add_breadcrumb :index, :dashboards_path

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]




  def index
    if current_user.admin?
      index_admin
    elsif current_user.regular?
      index_regular
    end
  end

  # def index_regular
  #   if params[:query]
  #     @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id, meli_order_id: params[:query]).includes(:label).paginate(page: params[:page], per_page: 30)
  #   elsif params[:print_status] == "Todas"
  #     @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id).includes(:label).paginate(page: params[:page], per_page: 30)
  #   else
  #   @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id).includes(:label).where(labels: {meli_first_date_printed: nil}).paginate(page: params[:page], per_page: 30)
  #     # if @shippings.count < 1
  #     #   redirect_to dashboards_path
  #     #   flash[:error] = "Estamos carregando suas etiquetas. Por favor aguarde um momento"
  #     # end
  #   end
  # end

  def index_regular
    if params[:query]
      if current_user.dashboards.first.boxes.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).count > 0
        @boxes = current_user.dashboards.first.boxes.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer)
        shippings = []
        @boxes.each do |box|
          shippings << box.shipping
        end
        @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
      elsif current_user.customers.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).count > 0
        @boxes = current_user.customers.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer)
        shippings = []
        @boxes.each do |box|
          shippings << box.shipping
        end    
        @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)            
      elsif current_user.customers.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).count > 0
        @boxes = current_user.customers.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer)
        shippings = []
        @boxes.each do |box|
          shippings << box.shipping
        end        
        @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)        
      end
    elsif params[:status_box_payment]
      @payments = Mercadolibre::Payment.where(dashboard_id: current_dashboard.id, status: params[:status_box_payment]).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)                  
    elsif params[:status_box_shipping]
      @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id, status: params[:status_box_shipping]).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)                        
    elsif params[:print_status] == "Todas"
      @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id).includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
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
      end      
    else
    @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id).includes(:label).where(labels: {meli_first_date_printed: nil}).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
      # if @shippings.count < 1
      #   redirect_to dashboards_path
      #   flash[:error] = "Estamos carregando suas etiquetas. Por favor aguarde um momento"
      # end
    end             
  end


  def index_admin
    if params[:query]
      if ::Box.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer).count > 0
        @boxes = ::Box.where("meli_item_id ilike :q or name ilike :q", q: "%#{params[:query]}%").includes(:payments,:shipping, :customer)
        shippings = []
        @boxes.each do |box|
          shippings << box.shipping
        end
        @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
      elsif ::Customer.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer).count > 0
        @boxes = ::Customer.where(email: params[:query]).first.boxes.includes(:payments,:shipping, :customer)
        shippings = []
        @boxes.each do |box|
          shippings << box.shipping
        end    
        @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)            
      elsif ::Customer.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer).count > 0
        @boxes = ::Customer.where(nickname: params[:query]).first.boxes.includes(:payments,:shipping, :customer)
        shippings = []
        @boxes.each do |box|
          shippings << box.shipping
        end        
        @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)        
      end
    elsif params[:status_box_payment]
      @payments = Mercadolibre::Payment.where(status: params[:status_box_payment]).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)            
    elsif params[:status_box_shipping]
      @shippings = Mercadolibre::Shipping.where(status: params[:status_box_shipping]).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)                        
    elsif params[:print_status] == "Todas"
      @shippings = Mercadolibre::Shipping.all.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
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
      end      
    else
    @shippings = Mercadolibre::Shipping.all.includes(:label).where(labels: {meli_first_date_printed: nil}).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
      # if @shippings.count < 1
      #   redirect_to dashboards_path
      #   flash[:error] = "Estamos carregando suas etiquetas. Por favor aguarde um momento"
      # end
    end             
  end  


  def meli_label
    box = ::Box.find params[:box_id]
    dashboard = current_user.dashboards.first
    refresh_token = dashboard.credentials[:refresh_token]
    Box.api.update_token(refresh_token)
    shipping_id = box.shipping.meli_shipping_id
    label = box.shipping.label.update(aircrm_date_printed: Time.now)
    redirect_to "https://api.mercadolibre.com/shipment_labels?shipment_ids=#{shipping_id}&savePdf=Y&access_token=#{dashboard.credentials[:access_token]}"
  end

  def multiple_meli_labels
    meli_shipping_ids = []
    boxes_ids = params[:box_id]
    boxes_ids.each do |box_id|
      box = ::Box.find box_id
      meli_shipping_id = box.shipping.meli_shipping_id
      label = box.shipping.label.update(aircrm_date_printed: Time.now, meli_first_date_printed: Time.now)
      meli_shipping_ids << meli_shipping_id
    end
    meli_shipping_ids_adjusted = meli_shipping_ids.join(",")
    dashboard = current_user.dashboards.first
    refresh_token = dashboard.credentials[:refresh_token]
    Box.api.update_token(refresh_token)
    redirect_to "https://api.mercadolibre.com/shipment_labels?shipment_ids=#{meli_shipping_ids_adjusted}&savePdf=Y&access_token=#{dashboard.credentials[:access_token]}"
  end
end
