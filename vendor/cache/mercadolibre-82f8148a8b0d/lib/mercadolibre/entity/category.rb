module Mercadolibre
  module Entity
    class Category
      def self.attr_list
        [:id, :name, :picture, :permalink, :total_items_in_this_category,
         :path_from_root, :children_categories, :attribute_types, :settings]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          v = if ['path_from_root', 'children_categories'].include?(k.to_s)
            v.map { |x| Category.new(x) }
          elsif k.to_s == 'settings'
            CategorySettings.new(v)
          end || v

          self.send("#{k}=", v) if self.respond_to?(k)
        end
      end

      def to_hash
        hash = {}

        self.class.attr_list.map do |k|
          value = self.send(k)

          unless value.nil?
            if['path_from_root', 'children_categories'].include?(k.to_s)
              value.map! { |x| x.to_hash if x.respond_to? :to_hash }
            else
              value = value.to_hash if value.respond_to? :to_hash
            end
            hash[k] = value
          end
        end
        hash
      end

      private

      attr_writer *attr_list
    end
  end
end
