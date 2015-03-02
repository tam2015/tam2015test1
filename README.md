## AirCRM (http://www.aircrm.com.br)

[![wercker status](https://app.wercker.com/status/fd17fcf426affa9d0ed19877095c2c08/m "wercker status")](https://app.wercker.com/project/bykey/fd17fcf426affa9d0ed19877095c2c08)

### Mercadolibre Test Users

###### - Usuários criados

```json
  var BUYER = {
    "id":172340277,
    "nickname":"TETE1898974",
    "password":"qatest4074",
    "site_status":"active",
    "email":"test_user_77014914@testuser.com"
  };
  var BUYER = {
    "id":172337095,
    "nickname":"TETE1900941",
    "password":"qatest5846",
    "site_status":"active",
    "email":"test_user_59401557@testuser.com"
  };

  #<--------->#
  var SELLER = {
    "id":172340300,
    "nickname":"TETE5626840",
    "password":"qatest2599",
    "site_status":"active",
    "email":"test_user_30857853@testuser.com"
  },
  var SELLER = {
    "id":172337145,
    "nickname":"TETE8512439",
    "password":"qatest5108",
    "site_status":"active",
    "email":"test_user_4606324@testuser.com"
  }
```

###### - Para criar um novo usuário:

```bash
$ curl -X POST -H "Content-Type: application/json" \
    -d '{ "site_id":"MLB" }' \
    https://api.mercadolibre.com/users/test_user?access_token=[KEY]
```

# Contributing

  NOTE: Create branches from `develop`.

### Development Environment

This project automates the setup of a development environment for Ruby on Rails. This is the easiest way to build a box with everything ready to start hacking, all in an isolated.



##### Requirements
* [azk](http://www.azk.io)
* terminal =)

----------

##### Install azk and Start Project

1. [Install](https://github.com/azukiapp/azk#installation-from-source) `azk`.

2. Check if `azk agent` is running:

      ```bash
      $ azk agent status
      ```

3. Clone the application locally:

      ```bash
      $ git clone git@bitbucket.org:aircrm/aircrm.git
      ```

4. Execute the application:

      ```bash
      $ azk start
      ```

  > NOTE:the first boot may take a few minutes because it will make downloading the images and provisioning systems

5. Check application status:

      ```bash
      $ azk status
      ```

6. Access the application through the `azk` built-in balancer:

      ```bash
      $ open http://aircrm.azk.dev
      ```


##### Requirements with Vagrant

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant](http://vagrantup.com)
* [Chef](http://www.getchef.com/chef/)
* [Vagrant Hostmanager](https://github.com/smdahlen/vagrant-hostmanager)

----------

1. Get project repository:

    ```bash
    # in terminal
    git clone git@bitbucket.org:thiagomartinho/aircrm.git && cd aircrm
    ```

2. Provision Vagrant VM:
  run to install chef cookbooks and provision vagrant:

    ```bash
    # in terminal
    chmod +x start.sh && ./start.sh
    ```

3. Project dependencies:
  access VM and install project depedencies:

    ```bash
    # in terminal
    vagrant ssh
    sh -c "`curl -fsSL https://raw.github.com/gullitmiranda/dotfiles/master/install.sh`"
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y postgresql-contrib-9.3
    sudo service postgresql restart
    gem install bundle mailcatcher foreman rubber
    exit
    ```

4. Project start:
  access VM, install gem and start DB:

    ```bash
    # in terminal
    vagrant ssh
    cd /vagrant
    bundle install
    rake db:create
    rake db:migrate
    ```

----------

##### Deployment
Our deploy process is built upon Amazon AWS and tools like Capistrano and Rubber.
First store AWS keys in ``~/.ec2`` inside virtual machine (Vagrant or Azk)
Then:  

```bash
bundle exec cap rubber:setup_aliases
bundle exec cap deloy:cold
```
