class Mercadolibre::CategoriesController < ApplicationController

  respond_to :json

  def index
    if params[:q]
      #@categories = Meli::CategorySuggest.find params[:q]
      @categories = Meli::Category.find(params[:q]).children_categories
    elsif params[:query]
      #@categories = Meli::CategorySuggest.find params[:q]
      @categories = Meli::CategorySuggest.find(params[:query])
    elsif params[:b]
      category_mother_id = Meli::Category.find(params[:b]).path_from_root.last(2).first.id
      @categories = Meli::Category.find(category_mother_id).children_categories
    else
      @categories = Meli::Category.all
      @count      = @categories.count
    end
  end

  def show
    record_id = params[:id] || params[:category_id]
    @category = Meli::Category.find(record_id)

    respond_with @category
  end

end
