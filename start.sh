#!/bin/sh

# set -e

# if [ -e /usr/local/bin/chef-solo ]; then
#   echo This kitchen is ready!
#   exit 0
# fi
sudo su

# Install dependecies
gem install chef --no-ri --no-rdoc
gem install bundler --no-ri --no-rdoc
gem install librarian-chef --no-ri --no-rdoc


# Install hostmanager vagrant plugin
vagrant plugin install vagrant-hostmanager

# Get chef cookbooks
librarian-chef install --clean --verbose

# Load vagrant
#  with force provision
vagrant up --provision

exit
