# encoding: utf-8
# This file originally created at http://rove.io/aa4300244fca2456275073741de33acf
# -*- mode: ruby -*-
# vi: set ft=ruby :

# General project settings
#################################

# NOTE: Remember to run "vagrant reload" after changing any of these

# IP Address for the host only network, change it to anything you like
# but please keep it within the IPv4 private network range
ip_address = "172.22.22.22"

# The project name is base for directories, hostname and alike
project_name = "aircrm"

#Vagrant.configure("1") do |config|
#  config.vm.boot_mode = :gui
#end

Vagrant.configure("2") do |config|

  config.vm.box = "aircrm"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_chef-11.4.0.box"
  config.ssh.forward_agent = true
  config.vm.hostname = "aircrm"
  # config.vm.network :private_network, ip: "192.168.33.33"

  # Set share folder
  config.vm.synced_folder "./"      , "/#{project_name}", umask: 755#, type: "nfs"
  config.vm.synced_folder "../"     , "/www"            , umask: 755#, type: "nfs"
  config.vm.synced_folder "~/.ec2"  , "/home/vagrant/.ec2"          , umask: 755#, type: "nfs"

  # config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :forwarded_port, guest: 22, host: 1234

  # Use hostonly network with a static IP Address and enable
  # hostmanager so we can have a custom domain for the server
  # by modifying the host machines hosts file
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.vm.define project_name do |node|
    node.vm.hostname = project_name + ".dev"
    node.vm.network :private_network, ip: ip_address
    # node.vm.network :forwarded_port, guest: 3000, host: 3000
    node.hostmanager.aliases = [ "www.#{project_name}.dev", "#{project_name}.local", "www.#{project_name}.local" ]
  end
  config.vm.provision :hostmanager


  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

  # Make sure that the newest version of Chef have been installed
  # config.vm.provision :shell, :inline => "apt-get update -qq && apt-get install make imagemagick --no-upgrade --yes"


  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe :apt
    chef.add_recipe "build-essential"
    chef.add_recipe "ubuntu"
    chef.add_recipe "locale"
    chef.add_recipe 'git'
    chef.add_recipe 'vim'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'

    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'mongodb::default'
    chef.add_recipe 'mongodb::10gen_repo'
    chef.add_recipe 'redisio::install'
    chef.add_recipe 'redisio::enable'

    chef.add_recipe 'nginx'

    chef.json = {
      :ubuntu    => {
        :locale  => "en_US.UTF-8"
      },
      :postgresql => {
        :version => "9.3",
        :enable_pgdg_apt => true,
        :contrib => {
          packages: ["postgresql-contrib-9.3"]
        },
        :config   => {
          :listen_addresses => "*",
          :port             => "5432"
        },
        :pg_hba   => [
          {
            :type   => "local",
            :db     => "postgres",
            :user   => "postgres",
            :addr   => nil,
            :method => "trust"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "0.0.0.0/0",
            :method => "md5"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "::1/0",
            :method => "md5"
          }
        ],
        :password => {
          :postgres => "postgres"
        }
      },
      :mongodb    => {
        :dbpath  => "/vagrant/tmp/mongodb",
        :logpath => "/vagrant/tmp/mongodb",
        :port    => "27017"
      },
      redisio: {
        # servers: [ {'name' => 'master', 'port' => '6379', 'unixsocket' => '/tmp/redis.sock', 'unixsocketperm' => '755'} ]
      },
      :git        => {
        :prefix => "/usr/local"
      },
      :rbenv      => {
        :user_installs => [
          {
            :user   => "vagrant",
            :rubies => [
              "2.1.2"
            ],
            :global => "2.1.2"#,
            # :gems => {
            #   :"2.1.2" => [
            #     { :"name" => "bundler"  },
            #     { :"name" => "rake"     },
            #     { :"name" => "foreman"  }
            #   ]
            # }
          }
        ]
      },
      :vim        => {
        :extra_packages => [
          "vim-rails"
        ]
      }
    }
  end
end
