module Mercadolibre
  class MeliInfo < ActiveRecord::Base
    belongs_to :item

    serialize :shipping
    serialize :seller_address
    serialize :geolocation

  end
end
