Rails.application.configure do
  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  config.assets.paths << Rails.root.join('app'    , 'assets', 'fonts')
  config.assets.paths << Rails.root.join('vendor' , 'assets', 'fonts')

  config.assets.paths << Rails.root.join('app'    , 'assets', 'javascripts', 'locales')
  config.assets.paths << Rails.root.join('app'    , 'assets', 'javascripts', 'locales', 'momment')

  config.assets.paths << Rails.root.join('app'    , 'assets', 'javascripts', 'plugins')

  # Precompile
  config.assets.precompile += %w( html5shiv.js respond.js )

  config.assets.precompile += %w( application_old.js home/application_old.css )

  config.assets.precompile += %w( home.js home.css )
  config.assets.precompile += %w( clean.js clean.css )

  config.assets.precompile += %w( locales/*.js )
  config.assets.precompile += %w( providers/* )
  config.assets.precompile << %w( .svg .eot .woff .ttf )
end

