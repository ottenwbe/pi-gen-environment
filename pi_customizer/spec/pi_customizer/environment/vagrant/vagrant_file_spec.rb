# Copyright (c) 2017 Beate Ottenwälder
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require_relative '../../../spec_helper'
require 'pi_customizer/build/environment/vagrant/vagrant_file'
require 'pi_customizer/build/workspace/local_workspace'
require 'fileutils'
require 'pathname'

module PiCustomizer

  RSpec.describe Environment::VagrantFileRenderer do

    let(:tmp_dir) {'tmp_vagrant_file'}
    let(:vagrant_file) {Environment::VagrantFile.new(Workspace::LocalWorkspace.new('', tmp_dir, ''), nil)}
    let(:vagrant_file_builder) {Environment::VagrantFileRenderer.new(vagrant_file)}

    after(:each) do
      FileUtils.rm_rf tmp_dir
    end

    it 'renders a Vagrantfile in the given temporary directory' do
      vagrant_file_builder.create_from_template
      expect(Pathname.new(tmp_dir+'/Vagrantfile')).to be_file
    end

    it 'renders a Vagrantfile which copies a gem to the vagrant box when the modifier_gem_path is given' do
      #Given
      gem_name = 'my_gem.gem'
      v_file = Environment::VagrantFile.new(Workspace::LocalWorkspace.new('', tmp_dir, gem_name), nil)
      v_file_builder = Environment::VagrantFileRenderer.new(v_file)
      #When
      v_file_builder.create_from_template
      #Then
      expect(File.read(tmp_dir+'/Vagrantfile').to_s).to match(/config.vm.provision 'file', source: [-a-zA-Z0-9'\/_]+#{gem_name}/)
    end

    it 'raises an error if the Vagrantfile.erb does not exist' do
      vagrant_file.vagrant_template_path = 'some/random/path'
      expect {vagrant_file_builder.create_from_template}.to raise_error("'Vagrantfile.erb' template not specified. Expected template in path 'some/random/path'")
    end

  end
end
