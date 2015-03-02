module Mercadolibre
  class VariationType < ActiveRecord::Base
    has_many :variation_to_types
    has_many :variations, through: :variation_to_types
  end
end
