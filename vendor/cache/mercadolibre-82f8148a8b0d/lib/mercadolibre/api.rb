module Mercadolibre
  class Api
    attr_accessor :access_token

    def initialize(args={})
      @credentials  = args[:credentials]

      @app_key      = args[:app_key]
      @app_secret   = args[:app_secret]
      @callback_url = args[:callback_url]
      @access_token = args[:access_token] || @credentials[:access_token] || @credentials[:token]

      @site         = args[:site        ] || 'MLA'
      @endpoint_url = args[:endpoint_url] || "https://api.mercadolibre.com"
      @auth_url     = args[:auth_url    ] || "http://auth.mercadolibre.com/authorization"
    end

    include Mercadolibre::Core::Auth
    include Mercadolibre::Core::CategoriesAndListings
    include Mercadolibre::Core::ItemsAndSearches
    include Mercadolibre::Core::LocationsAndCurrencies
    include Mercadolibre::Core::OrderManagement
    include Mercadolibre::Core::Questions
    include Mercadolibre::Core::Users


    def access_token
      @access_token
    end

    def access_token=(access_token)
      @access_token = access_token
    end

    def credentials
      @credentials || {}
    end

    def credentials=(credentials)
      access_token= credentials[:access_token]
      @credentials = credentials
    end


    private

    def get_request(action, params={}, headers={})
      token_expired? and update_token!
      Rails.logger.debug " ::ML::::::::: get_request: #{@endpoint_url}#{action}\n  params: #{{params: params}.merge(headers)} "

      begin
        parse_response(RestClient.get("#{@endpoint_url}#{action}", {params: params}.merge(headers)))
      rescue => e
        parse_response(e.response)
      end
    end

    def get_request_without_endpoint(action, params={}, headers={})
      begin
        parse_response(RestClient.get("#{action}?#{params.to_param}", headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def post_request(action, params={}, headers={}, check_expired=true)
      check_expired and token_expired? and update_token!

      begin
        parse_response(RestClient.post("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def put_request(action, params={}, headers={})
      token_expired? and update_token!

      begin
        parse_response(RestClient.put("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def patch_request(action, params={}, headers={})
      token_expired? and update_token!

      begin
        parse_response(RestClient.patch("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response(e.response)
      end
    end

    def head_request(action, params={})
      token_expired? and update_token!

      begin
        parse_response(RestClient.head("#{@endpoint_url}#{action}", params))
      rescue => e
        parse_response(e.response)
      end
    end

    def delete_request(action, params={})
      token_expired? and update_token!

      begin
        parse_response(RestClient.delete("#{@endpoint_url}#{action}", params))
      rescue => e
        parse_response(e.response)
      end
    end

    # Token
    def token_expired?
      Rails.logger.debug " ::ML::::::::: token_expired? => #{credentials[:token_expires_at].to_i} < #{Time.current.to_i} = #{credentials[:token_expires_at].to_i < Time.current.to_i}"
      credentials[:token_expires_at] and (credentials[:token_expires_at].to_i < Time.current.to_i)
    end

    def update_token!
      Rails.logger.debug " ::ML::::::::: update_token! => #{credentials}"
      update_token credentials[:refresh_token]
    end

    def parse_response(response)
      Rails.logger.debug " ::ML::::::::: response: #{response} "
      {
        headers: response.headers,
        body: (JSON.parse(response.body) rescue response.body),
        status_code: response.code
      }
    end
  end
end
