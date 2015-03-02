module Mercadolibre
  class MeliInfo < ActiveRecord::Base
    belongs_to :item

    serialize :shipping
    serialize :seller_address
    serialize :seller_contact
    serialize :location
    serialize :geolocation
    serialize :differential_pricing

  end
end
