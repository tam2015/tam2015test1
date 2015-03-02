class DashboardPreferences
  include Virtus.model

  # Notifications
  attribute :no_address_mailer        , Boolean , default: false



  ### Mercadolibre ###
  # I18n
  attribute :country_id               , String  , default: "BR"
  attribute :site_id                  , String  , default: "MLB"

  # MercadoPago
  attribute :mercadopago_tc_accepted  , Boolean , default: false
  attribute :mercadopago_account_type , String  , default: "personal"
  attribute :mercadoenvios            , String  , default: "not_accepted"

  #address
  attribute :seller_address           , Hash

  # Shipping
  attribute :shipping_modes           , Array   , default: []

  #feedback
  attribute :seller_feedback_message  , String    , default: "Comprador muito bom."

  # dump to hash (json and when necessary)
  def self.dump(attrs)
    attributes = attrs.to_hash if !attrs.nil? and attrs.respond_to? :to_hash
    Surus::Hstore::Serializer.new.dump(attributes)
  end

  def self.load(attrs)
    new Surus::Hstore::Serializer.new.load(attrs)
  end
end
