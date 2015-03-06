module Mercadolibre
  module Entity
    class Item
      def self.attr_list
        [ :id, :date_created, :last_updated, :buying_mode,
          :listing_type_id, :status, :sub_status, :site_id, :title, :subtitle,
          :seller_id, :category_id, :official_store_id, :price, :base_price,
          :original_price, :currency_id, :initial_quantity, :available_quantity,
          :sold_quantity, :start_time, :stop_time, :end_time, :condition,
          :permalink, :thumbnail, :secure_thumbnail, :pictures, :video_id,
          :descriptions, :accepts_mercadopago, :non_mercado_pago_payment_methods,
          :shipping, :seller_address, :seller_contact, :location, :geolocation,
          :coverage_areas, :attributes, :listing_source, :variations,
          :tags, :warranty, :catalog_product_id, :seller_custom_field,
          :parent_item_id, :differential_pricing, :automatic_relist
      ]
      end

      attr_reader *attr_list

      def initialize(attrs={})
        attrs.each do |k, v|
          if k.to_s == 'pictures'
            self.pictures = v.map { |x| ItemPicture.new(x) }
          elsif ['start_time', 'stop_time', 'end_time', 'last_updated', 'date_created'].include?(k.to_s)
            self.send("#{k}=", Time.parse(v)) if !v.nil? and self.respond_to?(k)
          elsif ['seller_address', 'location'].include?(k.to_s)
            self.send("#{k}=", Address.new(v)) if !v.nil? and self.respond_to?(k)
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end

        self.last_updated = self.date_created if self.last_updated.nil?
      end

      def to_hash
        hash = {}

        self.class.attr_list.map do |k|
          if self.respond_to?(k)
            value = self.send(k)

            if value.kind_of?(Array)
              value.map! {|_v| _v.respond_to?(:to_hash) ? _v.to_hash : _v }
            else
              value = value.to_hash if value.respond_to? :to_hash
            end
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
