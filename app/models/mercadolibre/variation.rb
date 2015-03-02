module Mercadolibre
  class Variation < ActiveRecord::Base
    belongs_to :item
    has_many :variation_to_types
    has_many :variation_types, through: :variation_to_types
  end
end
