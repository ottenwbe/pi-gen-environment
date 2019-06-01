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

require_relative '../../spec_helper'
require 'rspec'
require 'pi_customizer/build/builder/build_executor'
require 'pi_customizer/build/environment/environment'

describe PiCustomizer::Builder::BuildExecutor do

  it 'internally converts keys of skip steps to symbols' do
    build_exec = PiCustomizer::Builder::BuildExecutor.new(PiCustomizer::Environment::EnvironmentControl.new('',''), ['prepare'])
    expect(build_exec.skip_build_steps).to include(:prepare)
    expect(build_exec.skip_build_steps).not_to include('prepare')
  end


  it 'honors skipping the build step prepare' do
    build_exec = PiCustomizer::Builder::BuildExecutor.new(PiCustomizer::Environment::EnvironmentControl.new('',''), [:prepare])
    expect(build_exec.env).not_to receive(:prepare)
    build_exec.prepare
  end

  it 'honors skipping the build step start' do
    build_exec = PiCustomizer::Builder::BuildExecutor.new(PiCustomizer::Environment::EnvironmentControl.new('',''), [:start])
    expect(build_exec.env).not_to receive(:start)
    build_exec.start
  end

  it 'honors skipping the build step' do
    build_exec = PiCustomizer::Builder::BuildExecutor.new(PiCustomizer::Environment::EnvironmentControl.new('',''), [:build_image])
    expect(build_exec.env).not_to receive(:build_image)
    build_exec.build_image
  end

  it 'honors skipping the build step clean' do
    build_exec = PiCustomizer::Builder::BuildExecutor.new(PiCustomizer::Environment::EnvironmentControl.new('',''), [:clean_up])
    expect(build_exec.env).not_to receive(:clean_up)
    build_exec.clean_up
  end

  it 'honors skipping the build step stop' do
    build_exec = PiCustomizer::Builder::BuildExecutor.new(PiCustomizer::Environment::EnvironmentControl.new('',''), [:stop])
    expect(build_exec.env).not_to receive(:stop)
    build_exec.stop
  end
end
