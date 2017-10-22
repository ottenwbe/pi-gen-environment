require 'pi_build_environment/environment/vagrant'
require 'fileutils'
require 'pathname'

module PiCustomizer
  module Environment
    RSpec.describe Vagrant do

      let(:vagrant_env) {Vagrant.new}

      it 'checks for the existence of vagrant' do
        if system 'vagrant -v'
          expect{vagrant_env.check}.not_to raise_error
        else
          expect{vagrant_env.check}.to raise_error
        end
      end
    end
  end
end