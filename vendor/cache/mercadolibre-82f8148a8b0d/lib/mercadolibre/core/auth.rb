module Mercadolibre
  module Core
    module Auth
      def authenticate_url
        get_attrs = {
          response_type: 'code',
          client_id: @app_key,
          redirect_uri: CGI.escape(@callback_url)
        }.map { |k,v| "#{k}=#{v}" }.join('&')

        "#{@auth_url}?#{get_attrs}"
      end

      def authenticate(auth_code)
        response = post_request('/oauth/token', {
                  grant_type: 'authorization_code',
                  client_id: @app_key,
                  client_secret: @app_secret,
                  code: auth_code,
                  redirect_uri: @callback_url
                })[:body]

        @credentials = self.credentials= ({
                  access_token:   response['access_token' ],
                  refresh_token:  response['refresh_token'],
                  expired_at:     response['expires_in'   ].to_i.from_now.to_i
                })

        Mercadolibre::Entity::Auth.new(@credentials)
      end

      def update_token(refresh_token)
        params = {
          grant_type: 'refresh_token',
          client_id: @app_key,
          client_secret: @app_secret,
          refresh_token: refresh_token
        }

        Rails.logger.debug " ::ML::::::::: update_token => #{params}"

        response = post_request('/oauth/token', {
                grant_type: 'refresh_token',
                client_id: @app_key,
                client_secret: @app_secret,
                refresh_token: refresh_token
              }, {}, false)[:body]

        @old_credentials  = @credentials
        @credentials      = self.credentials= ({
                  access_token:   response['access_token' ],
                  refresh_token:  response['refresh_token'],
                  expired_at:     response['expires_in'   ].to_i
                })

        Mercadolibre::Entity::Auth.new(@credentials)
      end
    end
  end
end
