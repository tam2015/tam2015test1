module Mercadolibre
  class VariationToType < ActiveRecord::Base
    belongs_to :variation
    belongs_to :variation_type
  end
end
