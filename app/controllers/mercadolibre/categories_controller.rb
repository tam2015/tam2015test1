class Mercadolibre::CategoriesController < ApplicationController

  respond_to :json

  def index
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

  def show
    record_id = params[:id] || params[:category_id]
    @category = Meli::Category.find(record_id)

    respond_with @category
  end

end
