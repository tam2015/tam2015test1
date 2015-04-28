class Mercadolibre::ReceiptsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource

  # to fix
  add_breadcrumb :index, :dashboards_path

  # DashboardsHelper callback
  before_action :set_dashboard, only: [:index]


  def index
  end

  def show
	@box = ::Box.find params[:box_id]
  render :layout => false
  end


end

