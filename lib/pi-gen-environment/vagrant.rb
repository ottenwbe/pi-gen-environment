require 'fileutils'
require_relative 'logex'

class Vagrant
  def build
    $logger.info 'Building pi-image in local vagrant environment'
    Dir.chdir('envs/vagrant') do
      system 'vagrant destroy -f'
      system 'vagrant up --provider=virtualbox --provision'
    end
  end
end