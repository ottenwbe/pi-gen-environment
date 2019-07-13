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
require 'pi_customizer/build/environment/environment_factory'
require 'pi_customizer/build/environment/environment'
require 'pi_customizer/build/environment/docker/docker'
require 'pi_customizer/build/environment/vagrant/vagrant'

RSpec.describe 'environment_factory' do

  it 'creates a vagrant environment when ENV_VAGRANT is specified' do
    env = PiCustomizer::Environment::environment_factory(PiCustomizer::Environment::ENV_VAGRANT, '', '')
    expect(env).to be_a PiCustomizer::Environment::Vagrant
  end

  it 'creates a docker environment when ENV_DOCKER is specified' do
    env = PiCustomizer::Environment::environment_factory(PiCustomizer::Environment::ENV_DOCKER, '', '')
    expect(env).to be_a PiCustomizer::Environment::Docker
  end

  it 'creates an echo environment when ENV_ECHO is specified' do
    env = PiCustomizer::Environment::environment_factory(PiCustomizer::Environment::ENV_DOCKER, '', '')
    expect(env).to be_a PiCustomizer::Environment::Docker
  end

end