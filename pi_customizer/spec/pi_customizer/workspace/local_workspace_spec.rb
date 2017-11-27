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
require 'pi_customizer/workspace/local_workspace'
require 'fileutils'
require 'pathname'

module PiCustomizer
  module Workspace
    RSpec.describe LocalWorkspace do

      it 'uses default values for config_path and tmp_directory when no path is specified' do
        #Given
        #When
        local_config = LocalWorkspace.new('', '', '')
        #Then
        expect(local_config.config_path.to_s).to eq DEFAULT_CONFIG_PATH
        expect(local_config.workspace_directory.to_s).to eq DEFAULT_WORKSPACE_DIRECTORY
        expect(local_config.modifier_gem_path).to be nil
      end

      it 'accepts absolute paths for config_path and stores them as absolute paths' do
        #Given
        expected_cfg = '/home/test/cfg.json'
        expected_tmp = '/home/test/tmp'
        expected_mod = '/home/test/mod.gem'
        #When
        local_config = LocalWorkspace.new(expected_cfg, expected_tmp, expected_mod)
        #Then
        expect(local_config.config_path.to_s).to eq expected_cfg
        expect(local_config.workspace_directory.to_s).to eq expected_tmp
        expect(local_config.modifier_gem_path.to_s).to eq expected_mod
      end

      it 'accepts relative paths for config_path and stores them as absolute paths' do
        local_config = LocalWorkspace.new('a', 'b', 'c')
        expect(local_config.config_path.to_s).to eq File.join(Dir.pwd, '/a')
        expect(local_config.workspace_directory.to_s).to eq File.join(Dir.pwd, '/b')
        expect(local_config.modifier_gem_path.to_s).to eq File.join(Dir.pwd, '/c')
      end

      it 'allows us to check for value equality' do
        local_config_1 = LocalWorkspace.new('a', 'b', 'c')
        local_config_2 = LocalWorkspace.new('a', 'b', 'c')
        expect(local_config_1==local_config_2).to be true
      end

      it 'allows us to check for value inequality' do
        local_config_1 = LocalWorkspace.new('a', 'b', 'c')
        local_config_2 = LocalWorkspace.new('e', 'f', 'g')
        expect(local_config_1==local_config_2).to be false
      end

    end
  end
end