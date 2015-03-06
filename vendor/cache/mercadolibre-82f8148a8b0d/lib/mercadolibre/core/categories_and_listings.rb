module Mercadolibre
  module Core
    module CategoriesAndListings
      def get_sites
        results = get_request('/sites')

        results[:body].map { |r| Mercadolibre::Entity::Site.new(r) }
      end

      def get_site(site_id)
        result = get_request("/sites/#{site_id}")

        Mercadolibre::Entity::Site.new(result[:body])
      end

      def get_site_domain_info(domain)
        result = get_request("/site_domains/#{domain}")

        Mercadolibre::Entity::SiteDomain.new(result[:body])
      end

      def get_listing_types(site_id)
        results = get_request("/sites/#{site_id}/listing_types")

        results[:body].map { |r| Mercadolibre::Entity::ListingType.new(r) }
      end

      def get_listing_exposures(site_id)
        results = get_request("/sites/#{site_id}/listing_exposures")

        results[:body].map { |r| Mercadolibre::Entity::ListingExposure.new(r) }
      end

      def get_listing_prices(filters)
        valid_filters = ['price', 'listing_type_id', 'quantity', 'category_id', 'currency_id']
        filters.keep_if { |k,v| valid_filters.include?(k.to_s) }

        results = get_request("/sites/#{site_id}/listing_prices", filters)

        results[:body].map { |r| Mercadolibre::Entity::ListingPrice.new(r) }
      end

      def get_site_categories(site_id=nil)
        results = get_request("/sites/#{site_id || @site}/categories")

        results[:body].map { |r| Mercadolibre::Entity::Category.new(r) }
      end

      def get_category(category_id)
        result = get_request("/categories/#{category_id}")

        Mercadolibre::Entity::Category.new(result[:body])
      end

      def get_categories_suggest(filters)
        filters.reverse_merge!({
          seller: @site,
          sellType: "list"
        })
        results = get_request_without_endpoint("http://syi.mercadolivre.com.br/category/suggest", filters)[:body]

        if results.kind_of? Hash
          results["suggestedCategories"]#.map { |r| Mercadolibre::Entity::Category.new(r) }
        end
      end
    end
  end
end

