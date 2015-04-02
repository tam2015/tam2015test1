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

  def index_regular
    if params[:query]
      @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id, meli_order_id: params[:query]).includes(:label).paginate(page: params[:page], per_page: 7)
    elsif params[:print_status] == "não impressas"
      @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id).includes(:label).where(labels: {aircrm_date_printed: nil}).paginate(page: params[:page], per_page: 7)
    else
    @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id).includes(:label).paginate(page: params[:page], per_page: 7)
      if @shippings.count < 1
        redirect_to dashboards_path
        flash[:error] = "Estamos carregando suas etiquetas. Por favor aguarde um momento"
      end
    end
  end

  def index_admin
    if params[:query]
      @shippings = Mercadolibre::Shipping.all.where(meli_order_id: params[:query]).includes(:label).paginate(page: params[:page], per_page: 7)
    elsif params[:print_status] == "não impressas"
      @shippings = Mercadolibre::Shipping.all.includes(:label).where(labels: {aircrm_date_printed: nil}).paginate(page: params[:page], per_page: 7)
    else
      @shippings = Mercadolibre::Shipping.all.includes(:label).paginate(page: params[:page], per_page: 7)
      if @shippings.count < 1
        redirect_to dashboards_path
        flash[:error] = "Estamos carregando suas etiquetas. Por favor aguarde um momento"
      end
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
end
