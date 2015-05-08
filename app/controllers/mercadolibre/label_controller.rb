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
      @boxes = current_user.dashboards.first.boxes.where("tags && ARRAY['#{params[:status_box_payment]}']::character varying(255)[]").includes(:payments,:shipping, :customer).order(meli_order_id: :desc)
      shippings = []
      @boxes.each do |box|
        shippings << box.shipping
      end        
      @shippings = shippings#.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)        
    elsif params[:status_box_shipping]
      @boxes = current_user.dashboards.first.boxes.where("tags && ARRAY['#{params[:status_box_shipping]}']::character varying(255)[]").includes(:payments,:shipping, :customer).order(meli_order_id: :desc)
      shippings = []
      @boxes.each do |box|
        shippings << box.shipping
      end        
      @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)        
    elsif params[:print_status] == "Todas"
      @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id).includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
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
      @boxes = ::Box.where("tags && ARRAY['#{params[:status_box_payment]}']::character varying(255)[]").includes(:payments,:shipping, :customer).order(meli_order_id: :desc)
      shippings = []
      @boxes.each do |box|
        shippings << box.shipping
      end        
      @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)        
    elsif params[:status_box_shipping]
      @boxes = ::Box.where("tags && ARRAY['#{params[:status_box_shipping]}']::character varying(255)[]").includes(:payments,:shipping, :customer).order(meli_order_id: :desc)
      shippings = []
      @boxes.each do |box|
        shippings << box.shipping
      end        
      @shippings = shippings.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)        
    elsif params[:print_status] == "Todas"
      @shippings = Mercadolibre::Shipping.all.includes(:label).order(meli_order_id: :desc).paginate(page: params[:page], per_page: 30)
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
