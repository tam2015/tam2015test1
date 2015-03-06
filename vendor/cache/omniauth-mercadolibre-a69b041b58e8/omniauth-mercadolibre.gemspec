# -*- encoding: utf-8 -*-
# stub: omniauth-mercadolibre 0.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-mercadolibre"
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gullit Miranda"]
  s.date = "2015-03-06"
  s.description = "A MercadoLibre OAuth2 strategy for OmniAuth 1.x"
  s.email = ["gullitmiranda@requestdev.com.br"]
  s.files = [".gitignore", ".rspec", "CHANGELOG.md", "Gemfile", "Guardfile", "LICENSE", "README.md", "Rakefile", "lib/omniauth-mercadolibre.rb", "lib/omniauth-mercadolibre/version.rb", "lib/omniauth/strategies/mercadolibre.rb", "omniauth-mercadolibre.gemspec", "omniauth-mercadolibre.sublime-project", "spec/fixtures/vcr_cassettes/callback_phase.yml", "spec/fixtures/vcr_cassettes/request_phase.yml", "spec/omniauth/strategies/mercado_libre_spec.rb", "spec/spec_helper.rb", "test/dump/.gitignore", "test/dump/Gemfile", "test/dump/README.rdoc", "test/dump/Rakefile", "test/dump/app/assets/images/.keep", "test/dump/app/assets/javascripts/application.js", "test/dump/app/assets/javascripts/home.js.coffee", "test/dump/app/assets/stylesheets/application.css", "test/dump/app/assets/stylesheets/home.css.scss", "test/dump/app/controllers/application_controller.rb", "test/dump/app/controllers/concerns/.keep", "test/dump/app/controllers/home_controller.rb", "test/dump/app/controllers/users/omniauth_callbacks_controller.rb", "test/dump/app/helpers/application_helper.rb", "test/dump/app/helpers/home_helper.rb", "test/dump/app/mailers/.keep", "test/dump/app/models/.keep", "test/dump/app/models/concerns/.keep", "test/dump/app/models/user.rb", "test/dump/app/views/home/index.html.erb", "test/dump/app/views/layouts/application.html.erb", "test/dump/bin/bundle", "test/dump/bin/rails", "test/dump/bin/rake", "test/dump/config.ru", "test/dump/config/application.rb", "test/dump/config/boot.rb", "test/dump/config/database.yml", "test/dump/config/environment.rb", "test/dump/config/environments/development.rb", "test/dump/config/environments/production.rb", "test/dump/config/environments/test.rb", "test/dump/config/initializers/backtrace_silencers.rb", "test/dump/config/initializers/devise.rb", "test/dump/config/initializers/filter_parameter_logging.rb", "test/dump/config/initializers/inflections.rb", "test/dump/config/initializers/mime_types.rb", "test/dump/config/initializers/secret_token.rb", "test/dump/config/initializers/session_store.rb", "test/dump/config/initializers/wrap_parameters.rb", "test/dump/config/locales/devise.en.yml", "test/dump/config/locales/en.yml", "test/dump/config/routes.rb", "test/dump/db/migrate/20140120110923_devise_create_users.rb", "test/dump/db/schema.rb", "test/dump/db/seeds.rb", "test/dump/lib/assets/.keep", "test/dump/lib/tasks/.keep", "test/dump/log/.keep", "test/dump/public/404.html", "test/dump/public/422.html", "test/dump/public/500.html", "test/dump/public/favicon.ico", "test/dump/public/robots.txt", "test/dump/vendor/assets/javascripts/.keep", "test/dump/vendor/assets/stylesheets/.keep"]
  s.homepage = "https://github.com/gullitmiranda/omniauth-mercadolibre"
  s.rubygems_version = "2.2.2"
  s.summary = "A MercadoLibre OAuth2 strategy for OmniAuth 1.x"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth>, [">= 1.2.2", "~> 1.2"])
      s.add_runtime_dependency(%q<omniauth-oauth2>, [">= 1.2.0", "~> 1.2"])
      s.add_development_dependency(%q<rspec>, [">= 2.14.1", "~> 2.14"])
      s.add_development_dependency(%q<rack-test>, ["~> 0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0"])
      s.add_development_dependency(%q<webmock>, ["~> 0"])
    else
      s.add_dependency(%q<omniauth>, [">= 1.2.2", "~> 1.2"])
      s.add_dependency(%q<omniauth-oauth2>, [">= 1.2.0", "~> 1.2"])
      s.add_dependency(%q<rspec>, [">= 2.14.1", "~> 2.14"])
      s.add_dependency(%q<rack-test>, ["~> 0"])
      s.add_dependency(%q<simplecov>, ["~> 0"])
      s.add_dependency(%q<webmock>, ["~> 0"])
    end
  else
    s.add_dependency(%q<omniauth>, [">= 1.2.2", "~> 1.2"])
    s.add_dependency(%q<omniauth-oauth2>, [">= 1.2.0", "~> 1.2"])
    s.add_dependency(%q<rspec>, [">= 2.14.1", "~> 2.14"])
    s.add_dependency(%q<rack-test>, ["~> 0"])
    s.add_dependency(%q<simplecov>, ["~> 0"])
    s.add_dependency(%q<webmock>, ["~> 0"])
  end
end
