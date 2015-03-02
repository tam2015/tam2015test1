module Providers
  module Mercadolibre
    class Api
      def name
        :mercadolibre
      end

      def provided_by
        name
      end

      def initialize(args={})
        if !args[:credentials] and defined?(session) and session["mercadolibre.credentials"]
          args.reverse_merge!({ credentials: session["mercadolibre.credentials"] })
        end

        @meli ||= MercadolibreApi.new(args)
      end

      def client
        @meli
      end
    end
  end
end
