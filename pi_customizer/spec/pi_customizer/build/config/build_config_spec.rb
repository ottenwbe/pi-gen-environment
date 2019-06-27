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
require 'pi_customizer/build/config/build_config'

module PiCustomizer
  module Config
    RSpec.describe BuildConfig do

      it 'has a default config where no build steps are skipped' do
        build_config = BuildConfig.new
        expect(build_config.skip_build_steps.count).to eq 0
      end

      it 'allows us to specify build steps that need to be skipped' do
        build_config = BuildConfig.new(['test'])
        expect(build_config.skip_build_steps.count).to eq 1
        expect(build_config.skip_build_steps).to include :test
        expect(build_config.skip_build_steps).not_to include('test')
      end

      it 'allows us to query for individually skipped build steps' do
        build_config = BuildConfig.new(['test'])
        expect(build_config.skip? :test).to be true
      end

      it 'allows us to query for build steps that are not skipped' do
        build_config = BuildConfig.new(['test'])
        expect(build_config.skip? :foo).to be false
      end

    end
  end
end