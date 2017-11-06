# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantbox to execute unit tests in a clean environment

Vagrant.configure('2') do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.provision 'shell', inline: <<-SHELL
    sudo apt update
    sudo apt -y upgrade
    sudo apt -y install build-essential ruby-full 
    
    gem install bundler

    cd /vagrant/pi_customizer
    bundle install

    cd /vagrant/pi_build_modifier
    bundle install

    cd /vagrant

    rake spec
  SHELL
end
