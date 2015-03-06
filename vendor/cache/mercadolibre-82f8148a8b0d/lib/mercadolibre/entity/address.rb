module Mercadolibre
  module Entity
    class Address

      def self.attr_list
        [:id, :address_line, :street_name, :street_number, :comment, :zip_code,
        :city, :state, :country, :neighborhood, :municipality, :types, :latitude,
        :longitude, :is_valid_for_carrier, :receiver_name, :receiver_phone ]
      end

      attr_reader *attr_list

      #### Shipping Address Response
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

        ### Only Receiver
        # "receiver_name": "Gullit Miranda",
        # "receiver_phone": "1194260-9461"


      def initialize(attributes={})
        attributes.each do |k, v|
          if ['receiver_name', 'receiver_phone'].include?(k.to_s)
            self.send("#{k}=", v) unless v.nil?
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end

      def to_s
        address = []
        %w(address_line comment).each do |k, v|
          address << self.send(k) if self.respond_to?(k)
        end
        %w(neighborhood city state country zip_code).each do |k, v|
          if self.respond_to?(k)
            value = self.send(k)
            address << value["name"] if !value.nil? and value["name"]
          end
        end

        address << "CEP #{self.zip_code}" if self.respond_to?("zip_code") and !self.zip_code.nil?

        address.join(", ")
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
