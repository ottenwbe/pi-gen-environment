# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.provision 'shell', inline: <<-SHELL
    export PATH=$PATH:/root/.gem/ruby/2.3.0/bin
    sudo apt update
    sudo apt -y install build-essential ruby-full 
    gem install bundler 
    cd /vagrant
    ./install.sh
  SHELL
end
