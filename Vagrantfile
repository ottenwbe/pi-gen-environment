# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.provision 'shell', inline: <<-SHELL
    sudo apt update
    sudo apt -y install build-essential ruby-full 
    cd /vagrant
    rake spec
  SHELL
end
