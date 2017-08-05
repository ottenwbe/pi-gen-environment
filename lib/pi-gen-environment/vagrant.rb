require "fileutils"

class Vagrant
  def build
    Dir.chdir('envs/vagrant') do
      system 'vagrant destroy -f'
      system 'vagrant up --provider=virtualbox --provision'
    end
  end
end