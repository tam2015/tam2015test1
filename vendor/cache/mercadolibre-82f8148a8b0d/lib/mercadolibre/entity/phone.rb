module Mercadolibre
  module Entity
    class Phone
      def self.attr_list
        [:area_code, :number, :extension, :verified]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end

      def to_s
        phone = [self.area_code, self.number].map!{ |v| v && v.gsub(/[^0-9]/, "") }.join
        phone << "-#{self.extension}" unless self.extension.nil?
        phone.to_s
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
