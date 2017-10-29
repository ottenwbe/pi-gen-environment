require 'pi_customizer/environment/vagrant_file'
require 'fileutils'
require 'pathname'

module PiCustomizer
  module Environment
    RSpec.describe VagrantFileRenderer do

      let(:vagrant_file) {VagrantFile.new('', nil)}
      let(:vagrant_file_builder) {VagrantFileRenderer.new(vagrant_file)}

      it 'renders a valid file' do

        vagrant_file_builder.create_from_template

        expect(Pathname.new('envs/vagrant/Vagrantfile')).to be_file
      end

      it 'checks if the Vagrantfile.erb exists' do
        vagrant_file.vagrant_path = 'some/random/path'

        expect{vagrant_file_builder.create_from_template}.to raise_error("'Vagrantfile.erb' template not specified. Searching in path 'some/random/path'")
      end

    end
  end
end