# -*- encoding: utf-8 -*-
# stub: mercadolibre 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mercadolibre"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Matias Hick"]
  s.date = "2015-03-06"
  s.description = "Connect to Mercadolibre through Meli API"
  s.email = ["unformatt@gmail.com"]
  s.files = ["CHANGELOG.md", "LICENSE.md", "README.md", "lib/mercadolibre", "lib/mercadolibre.rb", "lib/mercadolibre/api.rb", "lib/mercadolibre/core", "lib/mercadolibre/core/auth.rb", "lib/mercadolibre/core/categories_and_listings.rb", "lib/mercadolibre/core/items_and_searches.rb", "lib/mercadolibre/core/locations_and_currencies.rb", "lib/mercadolibre/core/order_management.rb", "lib/mercadolibre/core/questions.rb", "lib/mercadolibre/core/users.rb", "lib/mercadolibre/entity", "lib/mercadolibre/entity/address.rb", "lib/mercadolibre/entity/answer.rb", "lib/mercadolibre/entity/auth.rb", "lib/mercadolibre/entity/category.rb", "lib/mercadolibre/entity/category_settings.rb", "lib/mercadolibre/entity/city.rb", "lib/mercadolibre/entity/country.rb", "lib/mercadolibre/entity/currency.rb", "lib/mercadolibre/entity/currency_conversion_ratio.rb", "lib/mercadolibre/entity/featured_item.rb", "lib/mercadolibre/entity/feedback.rb", "lib/mercadolibre/entity/item.rb", "lib/mercadolibre/entity/item_description.rb", "lib/mercadolibre/entity/item_picture.rb", "lib/mercadolibre/entity/listing_exposure.rb", "lib/mercadolibre/entity/listing_price.rb", "lib/mercadolibre/entity/listing_type.rb", "lib/mercadolibre/entity/order.rb", "lib/mercadolibre/entity/order_item.rb", "lib/mercadolibre/entity/payment.rb", "lib/mercadolibre/entity/payment_method.rb", "lib/mercadolibre/entity/phone.rb", "lib/mercadolibre/entity/question.rb", "lib/mercadolibre/entity/shipment.rb", "lib/mercadolibre/entity/site.rb", "lib/mercadolibre/entity/site_domain.rb", "lib/mercadolibre/entity/site_trend.rb", "lib/mercadolibre/entity/state.rb", "lib/mercadolibre/entity/user.rb", "lib/mercadolibre/entity/zip_code.rb", "lib/mercadolibre/version.rb"]
  s.homepage = "https://github.com/unformattmh/mercadolibre"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Connect to Mercadolibre through Meli API"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.5"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.6.7"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.5"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rest-client>, ["~> 1.6.7"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.5"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rest-client>, ["~> 1.6.7"])
  end
end
