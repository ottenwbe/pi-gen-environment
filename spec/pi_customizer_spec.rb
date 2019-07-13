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

require_relative 'spec_helper'
require 'fileutils'
require 'pi_customizer'
require 'pi_customizer/version'
require 'pi_customizer/build/config/local_workspace'
require 'pi_customizer/build/environment/environment_factory'
require 'pi_customizer/modify/modifiers'
require 'pi_customizer/utils/logex'


describe PiCustomizer::PiCustomizer do

  it 'informs about valid commands when called with no arguments' do
    expect {PiCustomizer::PiCustomizer.start([])}.to output(/Commands/).to_stdout
  end

  context '#build' do
    it 'starts a build when the command line parameter \'build\' is passed' do
      expect_any_instance_of(PiCustomizer::Builder::PiBuilder).to receive(:build).with(anything, anything)
      PiCustomizer::PiCustomizer.start(%w(build ECHO -c tst))
    end
    it 'reads the modifier_gem_path parameter' do
      expect(PiCustomizer::Environment).to receive(:environment_factory).with(PiCustomizer::Environment::ENV_ECHO, PiCustomizer::Workspace::LocalWorkspaceConfig.new('cfg', '', 'mod'), anything)
      PiCustomizer::PiCustomizer.start(%w(build ECHO --modifier_gem=mod --config_file=cfg))
    end
    it 'reads the local_workspace_dir parameter' do
      expect(PiCustomizer::Environment).to receive(:environment_factory).with(PiCustomizer::Environment::ENV_ECHO, PiCustomizer::Workspace::LocalWorkspaceConfig.new('cfg', 'tmp', ''), anything)
      PiCustomizer::PiCustomizer.start(%w(build ECHO --local_workspace_dir=tmp --config_file=cfg))
    end
    it 'reads the config_path parameter' do
      expect(PiCustomizer::Environment).to receive(:environment_factory).with(PiCustomizer::Environment::ENV_ECHO, PiCustomizer::Workspace::LocalWorkspaceConfig.new('cfg', '', ''), anything)
      PiCustomizer::PiCustomizer.start(%w(build ECHO --config_file=cfg))
    end
    it 'reads the remote_workspace_dir parameter' do
      expect(PiCustomizer::Environment).to receive(:environment_factory).with(PiCustomizer::Environment::ENV_ECHO, anything, PiCustomizer::Workspace::RemoteWorkspace.new('rdir', ''))
      PiCustomizer::PiCustomizer.start(%w(build ECHO --remote_workspace_dir=rdir  -c tst))
    end
    it 'reads the build_sources_git_url parameter' do
      expect(PiCustomizer::Environment).to receive(:environment_factory).with(PiCustomizer::Environment::ENV_ECHO, anything, PiCustomizer::Workspace::RemoteWorkspace.new('', 'git'))
      PiCustomizer::PiCustomizer.start(%w(build ECHO --build_sources_git_url=git  -c tst))
    end
    it 'logs unexpected errors' do
      expect($logger).to receive(:error).with(anything)
      allow(PiCustomizer::Environment).to receive(:environment_factory).and_throw('test throw')
      PiCustomizer::PiCustomizer.start(%w(build NONE -c "tst"))
    end
    it 'does not start if no config is provided' do
      expect(STDERR).to receive(:puts).with(anything)
      PiCustomizer::PiCustomizer.start(%w(build ECHO))
    end
  end

  context '#v' do
    it 'returns the app\'s version' do
      expect(STDOUT).to receive(:puts).with(PiCustomizer::VERSION)
      PiCustomizer::PiCustomizer.start(%w(v))
    end
  end

  context '#version' do
    it 'returns the app\'s version' do
      expect(STDOUT).to receive(:puts).with(PiCustomizer::VERSION)
      PiCustomizer::PiCustomizer.start(%w(version))
    end
  end

  context '#modify' do

    let(:tmp_json_config) {'tmp_config.json'}
    let(:tmp_workspace) {'tmp_space'}

    before do
      File.open(tmp_json_config, 'w') {|file| file.write('{}')}
      FileUtils.mkdir_p tmp_workspace
    end

    after do
      FileUtils.rm(tmp_json_config)
      FileUtils.rm_rf tmp_workspace
    end

    it 'is called by thor, when "pi_build_modifier modify" is called' do
      expect_any_instance_of(PiCustomizer::PiCustomizer).to receive(:modify).with(tmp_json_config, tmp_workspace)
      PiCustomizer::PiCustomizer.start(['modify', tmp_json_config, tmp_workspace])
    end

    it 'triggers the modifier task' do
      expect(PiCustomizer::Modifiers::ModifiersBuilder).to receive(:build_defaults).with(tmp_workspace, tmp_json_config).and_return(PiCustomizer::Modifiers::Modifiers.new)
      expect_any_instance_of(PiCustomizer::Modifiers::Modifiers).to receive(:modify_configs)
      PiCustomizer::PiCustomizer.start(['modify', tmp_json_config, tmp_workspace])
    end
  end

  context '#write' do
    it 'triggers the write of a given image to a given device' do
      allow(PiCustomizer::ImageWriter).to receive(:dispatch_write)
      expected_img = 'test.img'
      expected_dev = '/dev/null'
      expect_any_instance_of(PiCustomizer::ImageWriter).to receive(:write).with(expected_img, expected_dev)
      PiCustomizer::PiCustomizer.start(['write', "#{expected_img}", "#{expected_dev}"])
    end
    it 'logs unexpected errors' do
      expect($logger).to receive(:error).with(anything)
      allow(PiCustomizer::ImageWriter).to receive(:write).and_throw('test throw')
      PiCustomizer::PiCustomizer.start(%w'write img dev')
    end
  end

end