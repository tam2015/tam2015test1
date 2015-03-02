# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard 'rails' do
#   watch('Gemfile.lock')
#   watch(%r{^(config|lib)/.*})
# end

### Guard::Sidekiq
#  available options:
#  - :verbose
#  - :queue (defaults to "default") can be an array
#  - :concurrency (defaults to 1)
#  - :timeout
#  - :environment (corresponds to RAILS_ENV for the Sidekiq worker)
# guard 'sidekiq', :environment => 'development' do
#   watch(%r{^workers/(.+)\.rb$})
# end

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rsspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separetly)
#  * 'just' rspec: 'rspec'
guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch('spec/rails_helper.rb')                       { "spec" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
end


guard 'annotate' do
  watch( 'db/schema.rb' )

  # Uncomment the following line if you also want to run annotate anytime
  # a model file changes
  #watch( 'app/models/**/*.rb' )

  # Uncomment the following line if you are running routes annotation
  # with the ":routes => true" option
  #watch( 'config/routes.rb' )
end

# guard :test do
#   watch(%r{^test/.+_test\.rb$})
#   watch('test/test_helper.rb')  { 'test' }

#   # Non-rails
#   watch(%r{^lib/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }

#   # Rails 4
#   # watch(%r{^app/(.+)\.rb})                               { |m| "test/#{m[1]}_test.rb" }
#   # watch(%r{^app/controllers/application_controller\.rb}) { 'test/controllers' }
#   # watch(%r{^app/controllers/(.+)_controller\.rb})        { |m| "test/integration/#{m[1]}_test.rb" }
#   # watch(%r{^app/views/(.+)_mailer/.+})                   { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
#   # watch(%r{^lib/(.+)\.rb})                               { |m| "test/lib/#{m[1]}_test.rb" }

#   # Rails < 4
#   # watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
#   # watch(%r{^app/controllers/(.+)\.rb$})              { |m| "test/functional/#{m[1]}_test.rb" }
#   # watch(%r{^app/views/(.+)/.+\.erb$})                { |m| "test/functional/#{m[1]}_controller_test.rb" }
#   # watch(%r{^app/views/.+$})                          { 'test/integration' }
#   # watch('app/controllers/application_controller.rb') { ['test/functional', 'test/integration'] }
# end
