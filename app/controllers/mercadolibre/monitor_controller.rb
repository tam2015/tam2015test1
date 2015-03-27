class Mercadolibre::MonitorController < ApplicationController
  before_action :authenticate_user!

  before_action :set_dashboard, only: [:index]

  def monitor
	refresh_token = current_dashboard.credentials[:refresh_token]
    Mercadolibre::Item.api.update_token(refresh_token)  	
    @meli_items = Meli::Item.items_by_category_id params[:category_id]
    @items = @meli_items.results#.paginate(page: params[:page], per_page: 5)
  end

  def monitor_from_categories
    if params[:q]
      #@categories = Meli::CategorySuggest.find params[:q]
      @categories = Mercadolibre::Category.find_children_categories(params[:q])
    elsif params[:query]
      #@categories = Meli::CategorySuggest.find params[:q]
      @categories = Mercadolibre::Category.suggest_categories(params[:query])
    elsif params[:b]
      category_mother_id = Mercadolibre::Category.find_mothers_categories(params[:b])
    else
      @categories = Mercadolibre::Category.find_all_categories
      @count      = @categories.count
    end    
  end


end






