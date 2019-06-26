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
require 'pi_customizer/build/builder/builder_factory'
require 'pi_customizer/build/environment/environment_factory'

module PiCustomizer
  module Builder
    RSpec.describe 'builder_factory' do

      it 'creates a prepare_execute pi_builder when ENV_VAGRANT is specified' do
        builder = Builder::builder_factory(Environment::ENV_VAGRANT, nil, nil, nil)
        expect(builder).to be_a PrepareExecuteBuilder
      end

      it 'creates a start_execute pi_builder when ENV_DOCKER is specified' do
        builder = Builder::builder_factory(Environment::ENV_DOCKER, nil, nil, nil)
        expect(builder).to be_a StartExecuteBuilder
      end

    end
  end
end