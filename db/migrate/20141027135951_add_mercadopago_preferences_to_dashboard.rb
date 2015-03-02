class AddMercadopagoPreferencesToDashboard < ActiveRecord::Migration
  def up
    # lopps through all panels initializing them
    Dashboard.where(provider: "mercadolibre").each do |dashboard|
      begin
        user = Meli::User.me
      rescue OAuth2::Error => e
        # FEATURE: notify user that the account is not being synchronized because of the token.
        user = nil
      end

      if !user.nil?
        # user.shipping_modes
        dashboard.preferences.country_id                = user.country_id?                      if  user.country_id?
        dashboard.preferences.site_id                   = user.site_id?                         if  user.site_id?
        dashboard.preferences.mercadopago_tc_accepted   = user.status.mercadopago_tc_accepted?  if  user.status.mercadopago_tc_accepted?
        dashboard.preferences.mercadopago_account_type  = user.status.mercadopago_account_type? if  user.status.mercadopago_account_type?
        dashboard.preferences.mercadoenvios             = user.status.mercadoenvios?            if  user.status.mercadoenvios?
        dashboard.preferences.shipping_modes            = user.shipping_modes?                  if  user.shipping_modes?
        dashboard.save
      end
    end
  end
end
