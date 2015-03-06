module Mercadolibre
  module Entity
    class Auth
      def self.attr_list
        [:access_token, :refresh_token, :expired_at]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |attr, val|
          self.send("#{attr}=", val)
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
