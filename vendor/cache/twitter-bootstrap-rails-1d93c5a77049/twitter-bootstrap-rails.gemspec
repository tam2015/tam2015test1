# -*- encoding: utf-8 -*-
# stub: twitter-bootstrap-rails 3.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "twitter-bootstrap-rails"
  s.version = "3.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Seyhun Akyurek"]
  s.date = "2015-03-06"
  s.description = "twitter-bootstrap-rails project integrates Bootstrap CSS toolkit for Rails 3.1 Asset Pipeline"
  s.email = ["seyhunak@gmail.com"]
  s.files = ["README.md", "Rakefile", "app/assets", "app/assets/fonts", "app/assets/fonts/fontawesome-webfont.eot", "app/assets/fonts/fontawesome-webfont.svg", "app/assets/fonts/fontawesome-webfont.ttf", "app/assets/fonts/fontawesome-webfont.woff", "app/assets/fonts/glyphicons-halflings-regular.eot", "app/assets/fonts/glyphicons-halflings-regular.svg", "app/assets/fonts/glyphicons-halflings-regular.ttf", "app/assets/fonts/glyphicons-halflings-regular.woff", "app/assets/images", "app/assets/images/twitter", "app/assets/images/twitter/bootstrap", "app/assets/images/twitter/bootstrap/glyphicons-halflings-white.png", "app/assets/images/twitter/bootstrap/glyphicons-halflings.png", "app/assets/javascripts", "app/assets/javascripts/twitter", "app/assets/javascripts/twitter/bootstrap", "app/assets/javascripts/twitter/bootstrap.js", "app/assets/javascripts/twitter/bootstrap/affix.js", "app/assets/javascripts/twitter/bootstrap/alert.js", "app/assets/javascripts/twitter/bootstrap/button.js", "app/assets/javascripts/twitter/bootstrap/carousel.js", "app/assets/javascripts/twitter/bootstrap/collapse.js", "app/assets/javascripts/twitter/bootstrap/dropdown.js", "app/assets/javascripts/twitter/bootstrap/modal.js", "app/assets/javascripts/twitter/bootstrap/popover.js", "app/assets/javascripts/twitter/bootstrap/scrollspy.js", "app/assets/javascripts/twitter/bootstrap/tab.js", "app/assets/javascripts/twitter/bootstrap/tooltip.js", "app/assets/javascripts/twitter/bootstrap/transition.js", "app/assets/javascripts/twitter/bootstrap_ujs.js", "app/assets/stylesheets", "app/assets/stylesheets/twitter-bootstrap-static", "app/assets/stylesheets/twitter-bootstrap-static/bootstrap.css.erb", "app/assets/stylesheets/twitter-bootstrap-static/fontawesome.css.erb", "app/assets/stylesheets/twitter-bootstrap-static/sprites.css.erb", "app/helpers", "app/helpers/badge_label_helper.rb", "app/helpers/bootstrap_flash_helper.rb", "app/helpers/flash_block_helper.rb", "app/helpers/glyph_helper.rb", "app/helpers/modal_helper.rb", "app/helpers/navbar_helper.rb", "app/helpers/twitter_breadcrumbs_helper.rb", "app/views", "app/views/twitter-bootstrap", "app/views/twitter-bootstrap/_breadcrumbs.html.erb", "lib/generators", "lib/generators/bootstrap", "lib/generators/bootstrap/install", "lib/generators/bootstrap/install/install_generator.rb", "lib/generators/bootstrap/install/templates", "lib/generators/bootstrap/install/templates/application.css", "lib/generators/bootstrap/install/templates/application.js", "lib/generators/bootstrap/install/templates/bootstrap.coffee", "lib/generators/bootstrap/install/templates/bootstrap.js", "lib/generators/bootstrap/install/templates/bootstrap_and_overrides.css", "lib/generators/bootstrap/install/templates/bootstrap_and_overrides.less", "lib/generators/bootstrap/install/templates/en.bootstrap.yml", "lib/generators/bootstrap/layout", "lib/generators/bootstrap/layout/layout_generator.rb", "lib/generators/bootstrap/layout/templates", "lib/generators/bootstrap/layout/templates/layout.html.erb", "lib/generators/bootstrap/layout/templates/layout.html.haml", "lib/generators/bootstrap/layout/templates/layout.html.slim", "lib/generators/bootstrap/partial", "lib/generators/bootstrap/partial/partial_generator.rb", "lib/generators/bootstrap/partial/templates", "lib/generators/bootstrap/partial/templates/_login.html.erb", "lib/generators/bootstrap/themed", "lib/generators/bootstrap/themed/templates", "lib/generators/bootstrap/themed/templates/_form.html.erb", "lib/generators/bootstrap/themed/templates/_form.html.haml", "lib/generators/bootstrap/themed/templates/_form.html.slim", "lib/generators/bootstrap/themed/templates/edit.html.erb", "lib/generators/bootstrap/themed/templates/edit.html.haml", "lib/generators/bootstrap/themed/templates/edit.html.slim", "lib/generators/bootstrap/themed/templates/index.html.erb", "lib/generators/bootstrap/themed/templates/index.html.haml", "lib/generators/bootstrap/themed/templates/index.html.slim", "lib/generators/bootstrap/themed/templates/new.html.erb", "lib/generators/bootstrap/themed/templates/new.html.haml", "lib/generators/bootstrap/themed/templates/new.html.slim", "lib/generators/bootstrap/themed/templates/show.html.erb", "lib/generators/bootstrap/themed/templates/show.html.haml", "lib/generators/bootstrap/themed/templates/show.html.slim", "lib/generators/bootstrap/themed/templates/simple_form", "lib/generators/bootstrap/themed/templates/simple_form/_form.html.erb", "lib/generators/bootstrap/themed/templates/simple_form/_form.html.haml", "lib/generators/bootstrap/themed/templates/simple_form/_form.html.slim", "lib/generators/bootstrap/themed/themed_generator.rb", "lib/twitter", "lib/twitter-bootstrap-rails.rb", "lib/twitter/bootstrap", "lib/twitter/bootstrap/rails", "lib/twitter/bootstrap/rails/bootstrap.rb", "lib/twitter/bootstrap/rails/engine.rb", "lib/twitter/bootstrap/rails/twitter-bootstrap-breadcrumbs.rb", "lib/twitter/bootstrap/rails/version.rb", "vendor/assets", "vendor/assets/stylesheets", "vendor/assets/stylesheets/twitter-bootstrap-static", "vendor/assets/stylesheets/twitter-bootstrap-static/bootstrap.css.erb", "vendor/static-source", "vendor/static-source/bootstrap.less", "vendor/static-source/fontawesome.less", "vendor/static-source/sprites.less", "vendor/toolkit", "vendor/toolkit/fontawesome", "vendor/toolkit/fontawesome/bordered-pulled.less", "vendor/toolkit/fontawesome/core.less", "vendor/toolkit/fontawesome/fixed-width.less", "vendor/toolkit/fontawesome/font-awesome.less", "vendor/toolkit/fontawesome/icons.less", "vendor/toolkit/fontawesome/larger.less", "vendor/toolkit/fontawesome/list.less", "vendor/toolkit/fontawesome/mixins.less", "vendor/toolkit/fontawesome/path.less", "vendor/toolkit/fontawesome/rotated-flipped.less", "vendor/toolkit/fontawesome/spinning.less", "vendor/toolkit/fontawesome/stacked.less", "vendor/toolkit/fontawesome/variables.less", "vendor/toolkit/twitter", "vendor/toolkit/twitter/bootstrap", "vendor/toolkit/twitter/bootstrap/alerts.less", "vendor/toolkit/twitter/bootstrap/badges.less", "vendor/toolkit/twitter/bootstrap/bootstrap.less", "vendor/toolkit/twitter/bootstrap/breadcrumbs.less", "vendor/toolkit/twitter/bootstrap/button-groups.less", "vendor/toolkit/twitter/bootstrap/buttons.less", "vendor/toolkit/twitter/bootstrap/carousel.less", "vendor/toolkit/twitter/bootstrap/close.less", "vendor/toolkit/twitter/bootstrap/code.less", "vendor/toolkit/twitter/bootstrap/component-animations.less", "vendor/toolkit/twitter/bootstrap/dropdowns.less", "vendor/toolkit/twitter/bootstrap/forms.less", "vendor/toolkit/twitter/bootstrap/glyphicons.less", "vendor/toolkit/twitter/bootstrap/grid.less", "vendor/toolkit/twitter/bootstrap/input-groups.less", "vendor/toolkit/twitter/bootstrap/jumbotron.less", "vendor/toolkit/twitter/bootstrap/labels.less", "vendor/toolkit/twitter/bootstrap/list-group.less", "vendor/toolkit/twitter/bootstrap/media.less", "vendor/toolkit/twitter/bootstrap/mixins.less", "vendor/toolkit/twitter/bootstrap/modals.less", "vendor/toolkit/twitter/bootstrap/navbar.less", "vendor/toolkit/twitter/bootstrap/navs.less", "vendor/toolkit/twitter/bootstrap/normalize.less", "vendor/toolkit/twitter/bootstrap/pager.less", "vendor/toolkit/twitter/bootstrap/pagination.less", "vendor/toolkit/twitter/bootstrap/panels.less", "vendor/toolkit/twitter/bootstrap/popovers.less", "vendor/toolkit/twitter/bootstrap/print.less", "vendor/toolkit/twitter/bootstrap/progress-bars.less", "vendor/toolkit/twitter/bootstrap/responsive-utilities.less", "vendor/toolkit/twitter/bootstrap/scaffolding.less", "vendor/toolkit/twitter/bootstrap/tables.less", "vendor/toolkit/twitter/bootstrap/thumbnails.less", "vendor/toolkit/twitter/bootstrap/tooltip.less", "vendor/toolkit/twitter/bootstrap/type.less", "vendor/toolkit/twitter/bootstrap/utilities.less", "vendor/toolkit/twitter/bootstrap/variables.less", "vendor/toolkit/twitter/bootstrap/wells.less", "vendor/toolkit/twitter/bootstrap_base.less"]
  s.homepage = "https://github.com/seyhunak/twitter-bootstrap-rails"
  s.post_install_message = "Important: You may need to add a javascript runtime to your Gemfile in order for bootstrap's LESS files to compile to CSS. \n\n**********************************************\n\nExecJS supports these runtimes:\n\ntherubyracer - Google V8 embedded within Ruby\n\ntherubyrhino - Mozilla Rhino embedded within JRuby\n\nNode.js\n\nApple JavaScriptCore - Included with Mac OS X\n\nMicrosoft Windows Script Host (JScript)\n\n**********************************************\n"
  s.rubyforge_project = "twitter-bootstrap-rails"
  s.rubygems_version = "2.2.2"
  s.summary = "Bootstrap CSS toolkit for Rails 3.1 Asset Pipeline"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3.1"])
      s.add_runtime_dependency(%q<execjs>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, [">= 3.1"])
      s.add_development_dependency(%q<less>, [">= 0"])
      s.add_development_dependency(%q<therubyracer>, ["= 0.11.1"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<railties>, [">= 3.1"])
      s.add_dependency(%q<actionpack>, [">= 3.1"])
      s.add_dependency(%q<execjs>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 3.1"])
      s.add_dependency(%q<less>, [">= 0"])
      s.add_dependency(%q<therubyracer>, ["= 0.11.1"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1"])
    s.add_dependency(%q<actionpack>, [">= 3.1"])
    s.add_dependency(%q<execjs>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 3.1"])
    s.add_dependency(%q<less>, [">= 0"])
    s.add_dependency(%q<therubyracer>, ["= 0.11.1"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
