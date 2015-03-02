module Provider
  # Defaults methods to provider include in future
  module ModelBase
    module ClassMethods


      ###################
      # Helpers methods #
      ###################
      def attribute_names_sym
        fields.keys.map {|k| k.gsub(/^_/, "").to_sym }
      end





      #-----------------------#
      #       Defaults        #
      #-----------------------#


      def create_default(args); end
      def provider_after_create(args); end

      # def get             (*args); "default get"            ; end
      # def get!            (*args); "default get!"           ; end
      # def post            (*args); "default post"           ; end
      # def update_records  (*args); "default update_records" ; end
      # def update_record   (*args); "default update_record"  ; end

      # %W( get get! post update_records update_record ).map do |metod|
      #   puts "defined #{metod} ? = #{respond_to? metod}"
      #   unless respond_to? metod
      #     class_eval <<-METHODS
      #       def #{metod}(*args)
      #         "default method"
      #       end
      #     METHODS
      #   end
      # end










      # DEPRECATED - used with mercadolibre gem

      # extend ActiveModel::Naming
      # def model_name
      #   # ActiveModel::Name.new(name.split("::").last)
      #   ActiveModel::Name.new(self, Invoice)
      # end
      #-----------------------#
      #       Provider        #
      #-----------------------#

      def provided_by
      end

      # current_provider
      def provider
        Thread.current[:provider]
      end

      def provider=(provider)
        Thread.current[:provider] = provider
      end

      def provider?
        !!provider
      end

      # Api
      def api
        provider.client
      end

      def api?
        !!provider.client
      end





      def update_token(auth, old=nil)
        Rails.logger.debug " :::::   ModelBase.update_token: #{auth.to_json} \n #{old.to_json}\n"
        # @old_credentials: {:access_token=>"APP_USR-7835951963654614-060404-0cf831a58f48612e34b9b31a62d240b3__H_A__-158748360", :refresh_token=>"TG-538ed889e4b0d7fcecc33cdc", :expired_at=>21600}
        #     @credentials: {:access_token=>"APP_USR-7835951963654614-060404-d14000a30fe320e6864f5f85308e6852__I_N__-158748360", :refresh_token=>"TG-538ed88ce4b0165a5379455f", :expired_at=>21600}

        if old
          query = { refresh_token: old[:refresh_token] }
          params = {
            token:            auth[:access_token],
            refresh_token:    auth[:refresh_token],
            token_expires_at: auth[:expired_at].to_i
          }
        else
          query   = { uid: auth[:uid], provider: auth[:provider] }
          params = {
            token:            auth.credentials.token,
            refresh_token:    auth.credentials.refresh_token,
            token_expires_at: auth.credentials.expires_at.to_i
          }
        end

        Rails.logger.debug " :::::   ModelBase.update_token: #{query.to_json} \n #{params.to_json}\n"

        # return nil if params empty
        return unless params[:token] or params[:refresh_token] or params[:refresh_token]

        if dashboard = ::Dashboard.where(query).first
          dashboard.update(params)
        end
      end

    end

    module InstanceMethods
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods

      # delegate :model_name and :name to class without attributes with keys
      class_eval { delegate :model_name , to: :class } unless respond_to? :model_name
      class_eval { delegate :name       , to: :class } unless respond_to? :name
    end
  end
end
