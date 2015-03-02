Meli.configure do |config|

  config.after_refresh_token = Proc.new do |new_token, old_token|
    Rails.logger.debug " :::::   Meli.update_token: #{new_token.to_hash} \n #{old_token.to_hash}"

    return nil if !old_token.refresh_token or !new_token.token

    query   = { refresh_token: old_token.refresh_token }
    params  = { token:            new_token.token,
                refresh_token:    new_token.refresh_token,
                token_expires_at: new_token.expires_at.to_i }

    Rails.logger.debug " :::::   ModelBase.update_token: #{query.to_json} \n #{params.to_json}\n"

    if dashboard = ::Dashboard.where(query).first
      dashboard.update(params)
      dashboard.load_provider
    end
  end

end if defined? Meli



# Inicializa biblioteca meli antiga
class MercadolibreApi < Mercadolibre::Api
  def initialize(args={})

    super

    Rails.logger.debug " ::ML::::::::: initialize: #{args}  "

    @site         = args[:site        ] || 'MLB'
    @endpoint_url = args[:endpoint_url] || "https://api.mercadolibre.com"
    @auth_url     = args[:auth_url    ] || "http://auth.mercadolivre.com.br/authorization"

    @app_key    = ENV['MERCADOLIBRE_APP_ID']
    @app_secret = ENV['MERCADOLIBRE_APP_SECRET']
  end

  def update_token(refresh_token)
    super

    ::Dashboard.update_token(@credentials, @old_credentials)
  end
end
