class Mercadolibre::TrendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dashboard
  # load_and_authorize_resource



  # before_action do
  #   add_breadcrumb (@dashboard.name || :index ), dashboard_path(@dashboard)
  #   add_breadcrumb :index, :dashboard_items_path
  # end


  # def initialize(trend=nil)
  #   @trend = trend
  # end

  def main
    @trends = Meli::Trend.find "MLB"
  end

  def by_category
    query = params[:category]
    @trends = Meli::Trend.find_by_category_id "MLB", query
  end

end
