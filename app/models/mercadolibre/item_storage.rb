module Mercadolibre
  class ItemStorage < ActiveRecord::Base
    belongs_to :item
  end
end
