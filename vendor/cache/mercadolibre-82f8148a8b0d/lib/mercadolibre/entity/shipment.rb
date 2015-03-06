module Mercadolibre
  module Entity
    class Shipment

      def self.attr_list
        # Documentation
        [ :id, :status, :status_history, :date_created, :last_updated,
          :tracking_number, :sender_id, :receiver_id, :sender_address,
          :receiver_address, :shipping_items, :shipping_option, :comments,

          # order response
          :shipment_type, :date_created, :cost, :currency_id, :service_id, :date_first_printed, :shipping_mode, :substatus]
      end

      attr_reader *attr_list

      #### Shipping Response
        # {
          # "id": 21311032316,
          # "mode": "custom",
          # "created_by": "receiver",
          # "order_id": 837165680,
          # "order_cost": nil,
          # "site_id": "MLB",
          # "status": "pending",
          # "substatus": nil,
          # "status_history": {
            # "date_shipped": nil,
            # "date_delivered": nil
          # },
          # "date_created": "2014-05-13T09:28:07.000-04:00",
          # "last_updated": "2014-05-13T09:28:07.000-04:00",
          # "tracking_number": nil,
          # "tracking_method": nil,
          # "service_id": nil,
          # "sender_id": 158748360,
          # "sender_address": {
            # "id": 143405669,
            # "address_line": "Rua Loefgren 916",
            # "street_name": "Rua Loefgren",
            # "street_number": "916",
            # "comment": "AP 51",
            # "zip_code": "04040000",
            # "city": { "id": "BR-SP-44", "name": "São Paulo" },
            # "state": { "id": "BR-SP", "name": "São Paulo" },
            # "country": {"id": "BR", "name": "Brasil"},
            # "neighborhood": {"id": nil, "name": "Vila Clementino"},
            # "municipality": {"id": nil, "name": nil},
            # "types": ["default_selling_address", "shipping"],
            # "latitude": nil,
            # "longitude": nil,
            # "is_valid_for_carrier": nil
          # },
          # "receiver_id": 158748394,
          # "receiver_address": {
            # "id": 143409568,
            # "address_line": "Loefgren 916",
            # "street_name": "Loefgren",
            # "street_number": "916",
            # "comment": "AP 51",
            # "zip_code": "04040000",
            # "city": {"id": "BR-SP-44", "name": "São Paulo"},
            # "state": {"id": "BR-SP", "name": "São Paulo"},
            # "country": {"id": "BR", "name": "Brasil"},
            # "neighborhood": {"id": nil, "name": "Vila Clementino"},
            # "municipality": {"id": nil, "name": nil},
            # "types": ["default_buying_address"],
            # "latitude": nil,
            # "longitude": nil,
            # "is_valid_for_carrier": nil,
            # "receiver_name": "Gullit Miranda",
            # "receiver_phone": "1194260-9461"
          # },
          # "shipping_items": [{"id": "MLB559706000", "description": "Moto G", "quantity": 1, "dimensions": nil}],
          # "shipping_option": {"id": nil, "name": "add_shipping_cost", "currency_id": "BRL", "list_cost": 30, "cost": 30, "speed": nil },
          # "comments": nil,
          # "date_first_printed": nil,
          # "return_tracking_number": nil
        # }


      def initialize(attributes={})
        attributes.each do |k, v|
          if k.to_s == 'sender_address'
            self.sender_address = Address.new(v) unless v.nil?
          elsif k.to_s == 'receiver_address'
            self.receiver_address = Address.new(v) unless v.nil?
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
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
