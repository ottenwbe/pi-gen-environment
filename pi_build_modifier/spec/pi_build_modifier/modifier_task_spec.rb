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

require_relative '../spec_helper'
require 'rspec'
require 'fileutils'
require 'pi_build_modifier/modifier/pi_modifier'
require 'pi_build_modifier/modifier_task'


module PiBuildModifier
  RSpec.describe Task::Modifier do

    let(:json_config) {File.dirname(__FILE__) + '/../fixtures/config.json'}
    let(:workspace) {File.dirname(__FILE__) + '/' + 'tmp_workspace'}

    before do
      FileUtils::mkdir_p workspace
    end

    after do
      FileUtils.rm_rf workspace
    end

    it 'registers all default mappers' do
      #Given
      pi_modifier = PiModifier.new
      #When
      Task::Modifier.new(json_config, workspace, pi_modifier)
      #Then
      expect(pi_modifier.mappers.size).to be >= 1
    end

    it 'when the modification task is executed, modifications are made to the workspace directory' do
      #Given
      pi_modifier_task = Task::Modifier.new(json_config, workspace)

      #When
      pi_modifier_task.execute

      #Then
      expect(Dir["#{workspace}/**/*"].length).to be > 0
    end
  end

end
