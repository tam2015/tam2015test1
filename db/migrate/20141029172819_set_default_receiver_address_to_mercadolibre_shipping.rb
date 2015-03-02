class SetDefaultReceiverAddressToMercadolibreShipping < ActiveRecord::Migration
  def up
    shippings = Mercadolibre::Shipping.where(receiver_address: { "$in" => [nil, ""] } )
    shippings.update_all(receiver_address: {})
  end
end
