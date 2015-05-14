class AircrmPreference < ActiveRecord::Base
  serialize :data

  belongs_to :account
  belongs_to :dashboard

  def payment_status_to_portuguese
      payment_status = Mercadolibre::Payment.statuses.keys
      payment_status.map! { |status_in_english| I18n.t(status_in_english, scope: "helpers.aircrm_preferences.payment_status_to_portuguese", default: status_in_english) }  	
  end

  def shipping_status_to_portuguese
      shipping_status = Mercadolibre::Shipping.statuses.keys
      shipping_status.map! { |status_in_english| I18n.t(status_in_english, scope: "helpers.aircrm_preferences.shipping_status_to_portuguese", default: status_in_english) }  	
  end

end
