root = "/home/deployer/apps/aircrm/current"
working_directory root

pid "#{root}/tmp/pids/unicorn.pid"

stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 30
preload_app true

listen '/tmp/unicorn.spui.sock', backlog: 64

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(root, 'Gemfile')
end



# # Set your full path to application.
# app_dir = File.expand_path('../../', __FILE__)
# shared_dir = File.expand_path('../../../shared/', __FILE__)

# # Set unicorn options
# worker_processes 2
# preload_app true
# timeout 30

# # Fill path to your app
# working_directory app_dir

# # Set up socket location
# listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# # Loging
# stderr_path "#{shared_dir}/log/unicorn.stderr.log"
# stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# # Set master PID location
# pid "#{shared_dir}/pids/unicorn.pid"

# before_fork do |server, worker|
#   defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
#   old_pid = "#{server.config[:pid]}.oldbin"
#   if File.exists?(old_pid) && server.pid != old_pid
#     begin
#       sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
#       Process.kill(sig, File.read(old_pid).to_i)
#     rescue Errno::ENOENT, Errno::ESRCH
#       # someone else did our job for us
#     end
#   end
# end

# after_fork do |server, worker|
#   defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
# end

# before_exec do |server|
#   ENV['BUNDLE_GEMFILE'] = "#{app_dir}/Gemfile"
# end

