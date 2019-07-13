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

require_relative '../../../spec_helper'
require 'rspec'
require 'pi_customizer/build/builder/builder'
require 'pi_customizer/build/config/build_config'
require 'pi_customizer/build/environment/environment_factory'

describe PiCustomizer::Builder do

  context 'Builder' do

    it 'triggers the build executor' do
      builder = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::environment_factory(PiCustomizer::Environment::ENV_ECHO, nil, nil), PiCustomizer::Config::BuildConfig.new([]))
      expect(builder).to receive(:stop)
      builder.build
    end

  end

  context 'BuildExecutor' do

    it 'honors skipping the build step prepare' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([:prepare]))
      expect(build_exec.env).not_to receive(:prepare)
      build_exec.prepare
    end

    it 'honors skipping the build step start' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([:start]))
      expect(build_exec.env).not_to receive(:start)
      build_exec.start
    end

    it 'honors skipping the build step' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([:build_image]))
      expect(build_exec.env).not_to receive(:build_image)
      build_exec.build_image
    end

    it 'honors skipping the publish step' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([:publish]))
      expect(build_exec.env).not_to receive(:publish)
      build_exec.publish
    end

    it 'honors skipping the build step clean' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([:clean_up]))
      expect(build_exec.env).not_to receive(:clean_up)
      build_exec.clean_up
    end

    it 'honors skipping the build step stop' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([:stop]))
      expect(build_exec.env).not_to receive(:stop)
      build_exec.stop
    end

    it 'honors not skipping the build step check' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([]))
      expect(build_exec.env).to receive(:check)
      build_exec.check
    end

    it 'honors not skipping the build step prepare' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([]))
      expect(build_exec.env).to receive(:prepare)
      build_exec.prepare
    end

    it 'honors not skipping the build step start' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([]))
      expect(build_exec.env).to receive(:start)
      build_exec.start
    end

    it 'honors not skipping the build step' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([]))
      expect(build_exec.env).to receive(:build_image)
      build_exec.build_image
    end

    it 'honors not skipping the publish step' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([]))
      expect(build_exec.env).to receive(:publish)
      build_exec.publish
    end

    it 'honors not skipping the build step clean' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([]))
      expect(build_exec.env).to receive(:clean_up)
      build_exec.clean_up
    end

    it 'honors not skipping the build step stop' do
      build_exec = PiCustomizer::Builder::PiBuilder.new(PiCustomizer::Environment::EnvironmentControl.new('', ''), PiCustomizer::Config::BuildConfig.new([]))
      expect(build_exec.env).to receive(:stop)
      build_exec.stop
    end

  end

end
