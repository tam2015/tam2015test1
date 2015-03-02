class LabelController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  # to fix
  add_breadcrumb :index, :dashboards_path

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]

  def index

    @boxes = @dashboard.boxes.joins(:customer, :shipping).where("boxes.tags && ARRAY['paid']::character varying(255)[]").limit(15)
    # # select steps
    # @boxes = @dashboard.boxes.includes(:customer).where(" tags && ARRAY['paid']::character varying(255)[]").limit(15)
    # # @boxes = @dashboard.boxes.includes(:customer).where(" 'paid' = ANY (tags)").limit(15)
    # # collect boxes ids to query mongo with uniq request
    # boxes_ids = @boxes.pluck(:meli_order_id) #.map { |b| b.pid.to_i }
    # customers_ids = @boxes.pluck(:customer_id) #map { |b| b.customer_id.to_i }

    # @shippings_query = Mercadolibre::Shipping.where(:meli_order_id.in => boxes_ids)
    # @customers_query = Customer.find(customers_ids) # @dashboard.boxes.

    # @shippings = []
    # @shippings_query.map do |shipping|
    #   @shippings << shipping
    # end

    # @box_teste = []
    # @boxes.each do |box|
    #   box_serialized = box.serializable_hash
    #   ship = @shippings.select { |shipment| shipment.meli_order_id == box.meli_order_id }
    #   customer = @customers_query.select { |customer| customer.id == box.customer_id }
    #   box_serialized[:shipping_record] = ship
    #   box_serialized[:customer] = customer[0]
    #   @box_teste << box_serialized
    # end

    # #pry

  end
end
