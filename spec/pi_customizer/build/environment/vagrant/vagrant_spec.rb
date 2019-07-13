# Copyright (c) 2017-2019 Beate Ottenwälder
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

require_relative '../../../../spec_helper'
require 'fileutils'
require 'pathname'
require 'pi_customizer/build/config/remote_workspace'
require 'pi_customizer/build/config/local_workspace'
require 'pi_customizer/build/environment/vagrant/vagrant'

RSpec.describe PiCustomizer::Environment::Vagrant do

  let(:tmp_dir) {'tmp'}
  let(:vagrant_env) {PiCustomizer::Environment::Vagrant.new(PiCustomizer::Workspace::RemoteWorkspace.new,
                                                            PiCustomizer::Workspace::LocalWorkspaceConfig.new(
                                                                workspace_dir = tmp_dir))}

  after(:each) do
    FileUtils.mkdir_p tmp_dir
  end

  after(:each) do
    FileUtils.rm_rf tmp_dir
  end

  context '#check' do
    it 'checks for the existence of vagrant' do
      expect(vagrant_env).to receive(:system).with('vagrant -v').and_return(true)
      vagrant_env.check
    end
    it 'checks for the existence of vagrant' do
      expect(vagrant_env).to receive(:system).with('vagrant -v').and_return(false)
      expect {vagrant_env.check}.to raise_error
    end
  end

  context '#prepare' do
    it 'updates the vagrant box' do
      expect(vagrant_env).to receive(:system).with('vagrant box update')
      vagrant_env.prepare
    end
    it 'renders a vagrant file' do
      allow(vagrant_env).to receive(:system)
      vagrant_env.prepare
      expect(Pathname.new(File.join(tmp_dir, 'Vagrantfile'))).to be_file
    end
  end

  context '#modify' do
    it 'starts provisioning' do
      expect(vagrant_env).to receive(:system).with('vagrant ssh -- sudo pi_customizer modify /vagrant/config.json /build/pi-gen')
      vagrant_env.modify
    end
  end

  context '#build_image' do
    it 'starts provisioning' do
      expect(vagrant_env).to receive(:system).with('vagrant ssh -- sudo pi_customizer trigger /build/pi-gen /vagrant')
      vagrant_env.build_image
    end
  end

  context '#stop' do
    it 'stops and cleans up' do
      expect(vagrant_env).to receive(:system).with('vagrant destroy -f')
      vagrant_env.stop
    end
  end

end
