class Mercadolibre::MonitorController < ApplicationController
  before_action :authenticate_user!

  before_action :set_dashboard, only: [:index]

  def monitor
    if params[:text_search]
      refresh_token = current_user.dashboards.first.credentials[:refresh_token]
      Mercadolibre::Item.api.update_token(refresh_token)      
      @text_search = Meli::Item.search_by_text params[:text_search]
      @items = @text_search.results
      puts "\n\n\n\n\n\n\nitems#{@items.inspect}\n\n\n\n\n\n\n\n"
    else    
    	refresh_token = current_dashboard.credentials[:refresh_token]
      Mercadolibre::Item.api.update_token(refresh_token)  	
      @meli_items = Meli::Item.items_by_category_id params[:category_id]
      @items = @meli_items.results#.paginate(page: params[:page], per_page: 5)
    end
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
    elsif params[:text_search]
      redirect_to monitor_dashboards_path(text_search: params[:text_search])
    else
      @categories = Mercadolibre::Category.find_all_categories
      @count      = @categories.count
    end    
  end


end






