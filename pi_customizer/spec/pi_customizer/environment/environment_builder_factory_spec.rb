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
require 'pi_customizer/build/environment/environment_builder_factory'
require 'pi_customizer/build/environment/docker/docker'
require 'pi_customizer/build/environment/aws/aws'

module PiCustomizer
  module Environment
    RSpec.describe 'environment_factory' do

      it 'creates a vagrant environment when ENV_VAGRANT is specified' do
        env = Environment::environment_factory(ENV_VAGRANT, '', '')
        expect(env).to be_a Vagrant
      end

      it 'creates a docker environment when ENV_DOCKER is specified' do
        env = Environment::environment_factory(ENV_DOCKER, '', '')
        expect(env).to be_a Docker
      end

      it 'creates an AWS environment when ENV_AWS is specified' do
        env = Environment::environment_factory(ENV_AWS, '', '')
        expect(env).to be_a AWS
      end

    end
  end
end