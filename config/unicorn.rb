# unicorn_rails -c /srv/myapp/current/config/unicorn.rb -E production -D

rails_env = ENV['RAILS_ENV'] || 'development'

is_production = rails_env == 'production'
is_development = rails_env == 'development'

root = is_development ? `pwd`.gsub("\n", "") : "/mnt/aircrm-#{rails_env}/current"



working_directory root
worker_processes  Integer(ENV["WEB_CONCURRENCY"] || 3)
preload_app       true
timeout           30

if is_development
  listen      3000
  # listen 8080, :tcp_nopush => true

  pid         "#{root}/tmp/pids/unicorn.pid"
  stderr_path "#{root}/log/unicorn.log"
  stdout_path "#{root}/log/unicorn.log"
else
  listen      "/var/run/unicorn.sock", :backlog => 64

  # pid         "/srv/myapp/shared/pids/unicorn.pid"
  stderr_path "#{root}/log/unicorn.log"
  stdout_path "#{root}/log/unicorn.log"
end

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.
  #
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  # old_pid = "#{server.config[:pid]}.oldbin"
  # if old_pid != server.pid
  #   begin
  #     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
  #     Process.kill(sig, File.read(old_pid).to_i)
  #   rescue Errno::ENOENT, Errno::ESRCH
  #   end
  # end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
