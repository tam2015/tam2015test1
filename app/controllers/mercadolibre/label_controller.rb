class Mercadolibre::LabelController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # to fix
  add_breadcrumb :index, :dashboards_path

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]

  def index
    @shippings = Mercadolibre::Shipping.where(dashboard_id: current_dashboard.id).includes(:label) #::Box.all#current_user.dashboards.first.boxes.all#joins(:customer, :shipping).where("boxes.tags && ARRAY['not_paid']::character varying(255)[]").limit(15)
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
