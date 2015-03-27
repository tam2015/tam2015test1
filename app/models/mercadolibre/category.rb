module Mercadolibre
  class Category < ActiveRecord::Base

    def self.find_all_categories
        @categories = Meli::Category.all
    end

    def self.find_category category_id
        category = Meli::Category.find category_id
    end

    def self.find_children_categories category_id
        categories = Meli::Category.find category_id
        children_categories = categories.children_categories
    end

    def self.suggest_categories query
        categories = Meli::CategorySuggest.find query
    end

    def self.find_mothers_categories category_id
        categories = Meli::Category.find category_id
        category_mother_id = categories.path_from_root.last(2).first.id
        children_categories = Meli::Category.find(category_mother_id).children_categories
    end

  end
end