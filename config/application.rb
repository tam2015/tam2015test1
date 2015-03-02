require File.expand_path('../boot', __FILE__)

require 'dotenv'
Dotenv.load if defined? Dotenv

require 'rails/all'

# require "action_controller/railtie"
# require "action_mailer/railtie"
# require "rails/test_unit/railtie"
require "sprockets/railtie"

require 'csv'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w(development test), profiling: %w[staging development]))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# Bundler.require(*Rails.groups)

module Aircrm
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/lib/**/"]


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:en, :br]
    config.i18n.default_locale = :br
    config.i18n.fallbacks = [:en, :br]
    config.i18n.enforce_available_locales = false

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Disable strong parameters
    config.action_controller.permit_all_parameters = true

    routes.default_url_options = { host: ENV['HOST'] }

    # Generators
    config.app_generators.stylesheet_engine :less

    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end

    config.after_initialize do
      Dir[File.join(Rails.root, "lib", "extensions", "*.rb")].each {|extension| require extension }
    end

  end
end
