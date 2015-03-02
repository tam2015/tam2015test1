module Mercadolibre
  class Picture < ActiveRecord::Base
    belongs_to :item
  end
end
