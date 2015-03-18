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


namespace :sidekiq do
  def sidekiq_pid
    current_path + '../shared/pids/sidekiq.pid'
  end

  def pid_file_exists?
    test(*("[ -f #{sidekiq_pid} ]").split(' '))
  end

  def pid_process_exists?
    pid_file_exists? and test(*("kill -0 $( cat #{sidekiq_pid} )").split(' '))
  end

  task :start do
    on roles(:app) do
      if !pid_process_exists?
        #execute "cd #{current_path} && RAILS_ENV=#{fetch(:rails_env)} #{fetch(:rbenv_prefix)} bundle exec sidekiq -C config/sidekiq.yml -e #{fetch(:rails_env)} -L log/sidekiq.log -P #{sidekiq_pid} -d"
        execute "cd /home/deployer/apps/aircrm/current && ~/.rvm/bin/rvm default do bundle exec sidekiq --index 0 --pidfile /home/deployer/apps/aircrm/shared/tmp/pids/sidekiq.pid --environment production --logfile /home/deployer/apps/aircrm/shared/log/sidekiq.log --daemon"
      end
    end
  end

  task :stop do
    on roles(:app) do
      if pid_process_exists?
        execute "kill `cat #{sidekiq_pid}`"
        execute "rm #{sidekiq_pid}"
      end
    end
  end

  task :restart do
    on roles(:app) do
      invoke "sidekiq:stop"
      invoke "sidekiq:start"
    end
  end
end

after 'deploy:restart', 'sidekiq:start'



  # before "deploy", "sidekiq:quiet"
  # after "deploy:stop",    "sidekiq:stop"
  # after "deploy:start",   "sidekiq:start"
  # before "deploy:restart", "sidekiq:restart"

  # namespace :sidekiq do
  #   desc "Quiet sidekiq (stop accepting new work)"
  #   task :quiet, :roles => :app, :on_no_matching_servers => :continue do
  #     run "/usr/sbin/service sidekiq quiet"
  #   end

  #   desc "Stop sidekiq"
  #   task :stop, :roles => :app, :on_no_matching_servers => :continue do
  #     run "sudo /usr/bin/monit stop sidekiq"
  #   end

  #   desc "Start sidekiq"
  #   task :start, :roles => :app, :on_no_matching_servers => :continue do
  #     run "sudo /usr/bin/monit start sidekiq"
  #   end

  #   desc "Restart sidekiq"
  #   task :restart, :roles => :app, :on_no_matching_servers => :continue do
  #     run "sudo /usr/bin/monit restart sidekiq"
  #   end
  # end

#_______________________________


# before 'deploy',        "sidekiq:quiet"
# after "deploy:stop",    "sidekiq:stop"
# after "deploy:start",   "sidekiq:start"
# after "deploy:restart", "sidekiq:restart"

# namespace :sidekiq do
#   desc "Quiet sidekiq (stop accepting new work)"
#   task :quiet do
#     rsudo "if [ -d #{current_path} ]; then cd #{current_path} && if [ -f #{current_path}/tmp/pids/sidekiq.pid ]; then bundle exec sidekiqctl quiet #{current_path}/tmp/pids/sidekiq.pid ; fi; fi", :as => "deployer"
#   end

#   desc "Stop sidekiq"
#   task :stop do
#     # Allow workers up to 60 seconds to finish their processing.
#     rsudo "cd #{current_path} && if [ -f #{current_path}/tmp/pids/sidekiq.pid ]; then bundle exec sidekiqctl stop #{current_path}/tmp/pids/sidekiq.pid 60 ; fi", :as => "deployer"
#   end

#   desc "Start sidekiq"
#   task :start do
#     rsudo "cd #{current_path} ; bundle exec sidekiq -e #{Rubber.env} -d -C #{current_path}/config/sidekiq.yml -P #{current_path}/tmp/pids/sidekiq.pid -L #{current_path}/log/sidekiq.log"
#     sleep 45 # Give the workers some time to start up before moving on so monit doesn't try to start as well.
#   end

#   desc "Restart sidekiq"
#   task :restart do
#     stop
#     start
#   end
# end


#set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
