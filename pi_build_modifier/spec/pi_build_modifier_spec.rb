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
require 'pi_build_modifier'
require 'pi_build_modifier/version'
require 'pi_build_modifier/modifier_task'


RSpec.describe PiBuildModifier::PiBuildModifier do
  it 'has a version number' do
    expect(PiBuildModifier::VERSION).not_to be nil
  end

  it 'prints commands to stderr when called' do
    expect {PiBuildModifier::PiBuildModifier.start(ARGV)}.to output.to_stderr
  end

  context '#modify' do

    let(:tmp_json_config) {'tmp_config.json'}
    let(:tmp_workspace) {'tmp_space'}

    before do
      File.open(tmp_json_config, 'w') {|file| file.write('{}')}
      FileUtils.mkdir_p tmp_workspace
    end

    after do
      FileUtils.rm(tmp_json_config)
      FileUtils.rm_rf tmp_workspace
    end

    it 'to be called by thor' do
      expect_any_instance_of(PiBuildModifier::PiBuildModifier).to receive(:modify).with(tmp_json_config, tmp_workspace) #.and_return(test_task)
      PiBuildModifier::PiBuildModifier.start(['modify', tmp_json_config, tmp_workspace])
    end

    it 'to call the modifier task' do
      expect(PiBuildModifier::Task::Modifier).to receive(:new).with(tmp_json_config, tmp_workspace).and_return(PiBuildModifier::Task::Modifier.new(tmp_json_config, tmp_workspace))
      expect_any_instance_of(PiBuildModifier::Task::Modifier).to receive(:execute)
      PiBuildModifier::PiBuildModifier.start(['modify', tmp_json_config, tmp_workspace])
    end
  end
end



