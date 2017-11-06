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

require_relative '../../spec_helper'
require 'pi_customizer/workspace/local_config'
require 'fileutils'
require 'pathname'

module PiCustomizer
  module Workspace
    RSpec.describe LocalConfig do

      it 'uses default values when no path is specified' do
        local_config = LocalConfig.new('', '')
        expect(local_config.config_path).to eq LocalConfig::DEFAULT_CONFIG_PATH
        expect(local_config.tmp_directory).to eq LocalConfig::DEFAULT_TMP_DIRECTORY
      end

      it 'initializes fields with given parameters' do
        local_config = LocalConfig.new('a', 'b')
        expect(local_config.config_path).to eq 'a'
        expect(local_config.tmp_directory).to eq 'b'
      end

    end
  end
end