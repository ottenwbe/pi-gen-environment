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
require 'rspec'
require 'pi_customizer'
require 'pi_customizer/utils/logex'
require 'pi_customizer/version'
require 'pi_customizer/build/workspace/local_workspace'
require 'pi_customizer/utils/logex'


describe PiCustomizer::PiCustomizer do

  context 'build' do
    it 'starts a build when the command line parameter \'build\' is passed' do
      expect(PiCustomizer::Environment).to receive(:builder_factory).with(anything(), anything(), anything(), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO -c tst))
    end
    it 'reads the modifier_gem_path parameter' do
      expect(PiCustomizer::Environment).to receive(:builder_factory).with(anything(), PiCustomizer::Workspace::LocalWorkspace.new('cfg', '', 'mod'), anything(), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO --modifier_gem=mod --config_file=cfg))
    end
    it 'reads the local_workspace_dir parameter' do
      expect(PiCustomizer::Environment).to receive(:builder_factory).with(anything(), PiCustomizer::Workspace::LocalWorkspace.new('cfg', 'tmp', ''), anything(), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO --local_workspace_dir=tmp --config_file=cfg))
    end
    it 'reads the config_path parameter' do
      expect(PiCustomizer::Environment).to receive(:builder_factory).with(anything(), PiCustomizer::Workspace::LocalWorkspace.new('cfg', '', ''), anything(), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO --config_file=cfg))
    end
    it 'reads the remote_workspace_dir parameter' do
      expect(PiCustomizer::Environment).to receive(:builder_factory).with(anything(), anything(), PiCustomizer::Workspace::RemoteWorkspace.new('rdir', ''), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO --remote_workspace_dir=rdir  -c tst))
    end
    it 'reads the build_sources_git_url parameter' do
      expect(PiCustomizer::Environment).to receive(:builder_factory).with(anything(), anything(), PiCustomizer::Workspace::RemoteWorkspace.new('', 'git'), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO --build_sources_git_url=git  -c tst))
    end
    it 'logs unexpected errors' do
      expect($logger).to receive(:error).with(anything())
      allow(PiCustomizer::Environment).to receive(:builder_factory).and_throw('test throw')
      PiCustomizer::PiCustomizer.start(%w(build NONE -c "tst"))
    end
    it 'does not start if no config is provided' do
      expect(STDERR).to receive(:puts).with(anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO))
    end
  end

  context 'v' do
    it 'returns the app\'s version' do
      expect(STDOUT).to receive(:puts).with(PiCustomizer::VERSION)
      PiCustomizer::PiCustomizer.start(%w(v))
    end
  end

  context 'version' do
    it 'returns the app\'s version' do
      expect(STDOUT).to receive(:puts).with(PiCustomizer::VERSION)
      PiCustomizer::PiCustomizer.start(%w(version))
    end
  end

  context 'write' do
    it 'triggers the write of a given image to a given device' do
      allow(PiCustomizer::ImageWriter).to receive(:dispatch_write)
      expected_img = 'test.img'
      expected_dev = '/dev/null'
      expect_any_instance_of(PiCustomizer::ImageWriter).to receive(:write).with(expected_img, expected_dev)
      PiCustomizer::PiCustomizer.start(['write', "#{expected_img}", "#{expected_dev}"])
    end
  end

end