source "https://rubygems.org"
#source "https://Wh5Lz5WJrxTHfpFD62Zn@gem.fury.io/aircrm/"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.1.1"

gem "bcrypt", "~> 3.1.7"

gem "jquery-rails"
gem "jquery-ui-rails"
gem "twitter-bootstrap-rails", github: "seyhunak/twitter-bootstrap-rails", branch: "bootstrap3"
gem "select2-rails", "~> 3.5.0"

## Maybe SASS?
gem "less-rails"
# Remove ASAP
gem "haml-rails", "~> 0.5.3"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.0"

gem "unicorn", "~> 4.8.3"
gem "sidekiq"
# if you require "sinatra" you get the DSL extended to Object
gem "sinatra", "~> 1.4.5", require: nil

# PostgresSQL
gem "pg"
# Attributes on Steroids for Plain Old Ruby Objects
gem "virtus", github: "solnic/virtus"
# Surus adds PostgreSQL specific functionality to ActiveRecord. It adds helper methods for searching PostgreSQL arrays and hstores.
gem "surus", github: "JackC/surus"

# MongoID
gem "mongoid", "~> 4.0.0.rc1"
gem "mongoid-enum"    , github: "samuelb2/mongoid-enum"
gem "mongoid-paranoia", github: "simi/mongoid-paranoia"
gem "bson_ext"

gem "devise"
gem "devise_invitable"
gem "activerecord-session_store", github: "rails/activerecord-session_store"
gem "cancan"
gem "simple_form"
gem "country_select"
gem "paperclip"
gem "will_paginate", "~> 3.0"
gem "will_paginate_mongoid", "~> 2.0.1"
gem "redactor-rails"
gem "geocoder"

# omniauth
gem "omniauth"
gem "omniauth-mercadolibre", github: "gullitmiranda/omniauth-mercadolibre"
gem "mercadolibre", github: "gullitmiranda/mercadolibre"
#gem "meli", "~> 0.0.19"#, path: "/www/gems/meli"

gem "paypal-recurring"

# Rubber
gem "rubber", "~> 2.16.0"#, github: "rubber/rubber"
gem "open4"

gem "carrierwave-mongoid", :require => "carrierwave/mongoid"
gem "mongoid-grid_fs", github: "ahoward/mongoid-grid_fs"
gem "mini_magick", "~> 3.7.0"

group :assets do
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem "therubyracer", platforms: :ruby, require: "v8"
  gem "sprockets"
  gem "coffee-rails", "~> 4.0.0"
  gem "i18n-js", "~> 3.0.0.rc7"
  gem "yui-compressor"
  # Use Uglifier as compressor for JavaScript assets
  gem "uglifier", ">= 1.3.0"
  gem "backbone-on-rails"
end

# Roo can access the contents of various spreadsheet files.
gem "roo"
gem "to_xls", "~> 1.5.3"
# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "pry-rails"
  gem "annotate", "~> 2.6.5"
end

group :development, :test do
  gem "rspec"
  gem "rspec-rails"
  gem "rspec-nc"
  gem "guard"
  gem "guard-rails"
  gem "guard-sidekiq"
  gem "guard-rspec"
  gem "guard-annotate"
  gem "guard-test"
  gem "rails-dev-tweaks"
  gem "awesome_print"
  gem "factory_girl_rails"
end

group :production, :staging do
  gem "dotenv"
  gem "newrelic_rpm"
end

gem "bullet", group: :development
