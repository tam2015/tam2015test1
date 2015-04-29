class Mercadolibre::ReceiptsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource

  # to fix
  add_breadcrumb :index, :dashboards_path

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]


  def index
    if params[:query]
      @boxes = current_user.boxes.where(meli_order_id: params[:query]).paginate(page: params[:page], per_page: 5)
    else    
      @boxes = current_user.boxes.paginate(page: params[:page], per_page: 5)
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

