lock '3.3.5'

set :application, 'aircrm'
set :repo_url, 'https://github.com/tam2015/tam2015test1'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :use_sudo, false
set :bundle_binstubs, nil
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:reload'
  end
end
