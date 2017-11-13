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

require_relative 'spec_helper'
require 'fileutils'
require 'rspec'
require 'pi_customizer'
require 'pi_customizer/utils/logex'
require 'pi_customizer/version'
require 'pi_customizer/workspace/local_workspace'


describe PiCustomizer::PiCustomizer do

  context 'build' do
    it 'starts a build when the command line parameter \'build\' is passed' do
      expect(PiCustomizer::Environment).to receive(:environment_builder_factory).with(anything(), anything(), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO))
    end
    it 'reads the modifier_gem_path parameter' do
      expect(PiCustomizer::Environment).to receive(:environment_builder_factory).with(anything(), PiCustomizer::Workspace::LocalWorkspace.new('', '', 'mod'), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO --modifier_gem_path=mod))
    end
    it 'reads the tmp_dir parameter' do
      expect(PiCustomizer::Environment).to receive(:environment_builder_factory).with(anything(), PiCustomizer::Workspace::LocalWorkspace.new('', 'tmp', ''), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO --tmp_folder=tmp))
    end
    it 'reads the config_path variable' do
      expect(PiCustomizer::Environment).to receive(:environment_builder_factory).with(anything(), PiCustomizer::Workspace::LocalWorkspace.new('cfg', '', ''), anything())
      PiCustomizer::PiCustomizer.start(%w(build ECHO --config_file=cfg))
    end
    it 'reads the git_build_sources variable' do
      expect(PiCustomizer::Environment).to receive(:environment_builder_factory).with(anything(), anything(), PiCustomizer::Workspace::RemoteWorkspace.new('', 'git'))
      PiCustomizer::PiCustomizer.start(%w(build ECHO --git_build_sources=git))
    end
  end

  context 'version' do
    it 'returns the app\'s version' do
      expect(STDOUT).to receive(:puts).with(PiCustomizer::VERSION)
      PiCustomizer::PiCustomizer.start(%w(version))
    end

  end
end