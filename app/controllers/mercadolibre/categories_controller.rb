class Mercadolibre::CategoriesController < ApplicationController

  respond_to :json

  def index
    if params[:q]
      @categories = Meli::CategorySuggest.find params[:q]
    else
      @categories = Meli::Category.all
      @count      = @categories.count
    end

    respond_with @categories
  end

  def show
    record_id = params[:id] || params[:category_id]
    @category = Meli::Category.find(record_id)

    respond_with @category
  end

end
