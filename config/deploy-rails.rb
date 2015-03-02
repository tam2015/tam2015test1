namespace :rails do
  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    # exec %Q(ssh -v -i ~/.ec2/gsg-keypair root@#{server.host} -t '#{current_path}/bin/rails console')
    # run_interactively "bin/rails console #{rails_env}"
    run_interactively "bundle exec rails console #{rails_env}"
  end

  desc "Open the rails dbconsole on one of the remote servers"
  task :dbconsole, :roles => :app do
    run_interactively "bundle exec rails dbconsole #{rails_env}"
  end
end

desc "Bash profile to first app server"
task :bash, :roles => :app do
  # run_ssh "/bin/bash -i"
  run_ssh <<-ENDSCRIPT
    cd #{current_path}
    /bin/bash -i
  ENDSCRIPT
end




# Methods

def run_interactively(command, server=nil)
  run_ssh <<-ENDSCRIPT
    cd #{current_path}
    #{command}
  ENDSCRIPT
end

def run_ssh(command, server=nil)
  server ||= find_servers_for_task(current_task).first
  exec %Q(ssh -i ~/.ec2/gsg-keypair root@#{server.host} -t '#{command}')
end
