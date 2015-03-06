module Mercadolibre
  module Entity
    class User
      # include Mercadolibre::Entity::Base

      # DUMP
      # "get_my_user.id": {
        # "id": 158748360,
        # "nickname": "TETE6572348",
        # "registration_date": "2014-05-13T08:56:41.000-04:00",
        # "first_name": "Test",
        # "last_name": "Test",
        # "country_id": "BR",
        # "email": "test_user_92591944@testuser.com",
        # "identification": {
        #   "type": "CPF",
        #   "number": "111111111111"
        # },
        # "address": {
        #   "state": "BR-SP",
        #   "city": "São Paulo",
        #   "address": "Rua Loefgren 916",
        #   "zip_code": "04040000"
        # },
        # "phone": {
        #   "area_code": "01",
        #   "number": "1111-1111",
        #   "extension": "",
        #   "verified": false
        # },
        # "alternative_phone": {
        #   "area_code": "",
        #   "number": "",
        #   "extension": ""
        # },
        # "user_type": "normal",
        # "tags": [
        #   "normal",
        #   "test_user"
        # ],
        # "logo": null,
        # "points": 2,
        # "site_id": "MLB",
        # "permalink": "http://perfil.mercadolivre.com.br/TETE6572348",
        # "shipping_modes": [
        #   "custom",
        #   "not_specified",
        #   "me2"
        # ],
        # "seller_experience": "ADVANCED",
        # "seller_reputation": {
        #   "level_id": "5_green",
        #   "power_seller_status": null,
        #   "transactions": {
        #     "period": "historic",
        #     "total": 11,
        #     "completed": 11,
        #     "canceled": 0,
        #     "ratings": {
        #       "positive": 1,
        #       "negative": 0,
        #       "neutral": 0
        #     }
        #   }
        # },
        # "buyer_reputation": {
        #   "canceled_transactions": 0,
        #   "transactions": {
        #     "period": "historic",
        #     "total": null,
        #     "completed": null,
        #     "canceled": {
        #       "total": null,
        #       "paid": null
        #     },
        #     "unrated": {
        #       "total": null,
        #       "paid": null
        #     },
        #     "not_yet_rated": {
        #       "total": null,
        #       "paid": null,
        #       "units": null
        #     }
        #   }
        # },
        # "status": {
        #   "site_status": "active",
        #   "list": {
        #     "allow": true,
        #     "codes": [],
        #     "immediate_payment": {
        #       "required": false,
        #       "reasons": []
        #     }
        #   },
        #   "buy": {
        #     "allow": true,
        #     "codes": [],
        #     "immediate_payment": {
        #       "required": false,
        #       "reasons": []
        #     }
        #   },
        #   "sell": {
        #     "allow": true,
        #     "codes": [],
        #     "immediate_payment": {
        #       "required": false,
        #       "reasons": []
        #     }
        #   },
        #   "billing": {
        #     "allow": true,
        #     "codes": []
        #   },
        #   "mercadopago_tc_accepted": true,
        #   "mercadopago_account_type": "personal",
        #   "mercadoenvios": "not_accepted",
        #   "immediate_payment": false,
        #   "confirmed_email": false
        # },
        # "credit": {
        #   "consumed": 2560,
        #   "credit_level_id": "MLB5"
        # }
      # }

      def self.attr_list
        [:id, :nickname, :registration_date, :first_name, :last_name, :country_id, :email,
          :identification, :address, :phone, :alternative_phone, :user_type, :tags, :logo,
          :points, :site_id, :permalink, :shipping_modes, :seller_experience, :seller_reputation,
          :buyer_reputation, :status, :credit,
          # Usa?
          :blocked, :billing_info]
      end

      # adaptar
        # "identification": {
        #   "type": "CPF",
        #   "number": "111111111111"
        # },
        # "address": {
        #   "state": "BR-SP",
        #   "city": "São Paulo",
        #   "address": "Rua Loefgren 916",
        #   "zip_code": "04040000"
        # },
        # "seller_reputation": {
        #   "level_id": "5_green",
        #   "power_seller_status": null,
        #   "transactions": {
        #     "period": "historic",
        #     "total": 11,
        #     "completed": 11,
        #     "canceled": 0,
        #     "ratings": {
        #       "positive": 1,
        #       "negative": 0,
        #       "neutral": 0
        #     }
        #   }
        # },
        # "buyer_reputation": {
        #   "canceled_transactions": 0,
        #   "transactions": {
        #     "period": "historic",
        #     "total": null,
        #     "completed": null,
        #     "canceled": {
        #       "total": null,
        #       "paid": null
        #     },
        #     "unrated": {
        #       "total": null,
        #       "paid": null
        #     },
        #     "not_yet_rated": {
        #       "total": null,
        #       "paid": null,
        #       "units": null
        #     }
        #   }
        # },
        # "status": {
        #   "site_status": "active",
        #   "list": {
        #     "allow": true,
        #     "codes": [],
        #     "immediate_payment": {
        #       "required": false,
        #       "reasons": []
        #     }
        #   },
        #   "buy": {
        #     "allow": true,
        #     "codes": [],
        #     "immediate_payment": {
        #       "required": false,
        #       "reasons": []
        #     }
        #   },
        #   "sell": {
        #     "allow": true,
        #     "codes": [],
        #     "immediate_payment": {
        #       "required": false,
        #       "reasons": []
        #     }
        #   },
        #   "billing": {
        #     "allow": true,
        #     "codes": []
        #   },
        #   "mercadopago_tc_accepted": true,
        #   "mercadopago_account_type": "personal",
        #   "mercadoenvios": "not_accepted",
        #   "immediate_payment": false,
        #   "confirmed_email": false
        # },
        # "credit": {
        #   "consumed": 2560,
        #   "credit_level_id": "MLB5"
        # }


      attr_reader *attr_list

      def initialize(attributes={})

        attributes.each do |k, v|
          v = if k.to_s == 'registration_date'
            Time.parse(v)
          elsif ['tags', 'shipping_modes'].include?(k.to_s)
            v.join(",")
          elsif k.to_s == 'phone'
            Phone.new(v)
          end || v

          self.send("#{k}=", v) if self.respond_to?(k) and !v.nil?
        end
      end

      def to_hash
        hash = {}

        self.class.attr_list.map do |k|
          if self.respond_to?(k)
            value = self.send(k)
            value = value.to_hash if value.respond_to? :to_hash
          else
            value = nil
          end

          hash[k] = value unless value.nil?
        end
        hash
      end

      private

      attr_writer *attr_list
    end
  end
end
