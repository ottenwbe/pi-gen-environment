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
require 'rspec'
require 'fileutils'
require 'pi_build_modifier/sys_tweaks/run_modifier'
require 'pi_build_modifier/modifier/pi_modifier'
require 'pi_build_modifier/modifier/mapper'

RSpec.describe PiBuildModifier::RunModifier do

  let(:workspace) {File.dirname(__FILE__) + '/workspace'}

  before do
    FileUtils.mkdir_p workspace
  end

  after do
    FileUtils.rm_rf workspace
  end

  it 'should be of type Mapper' do
    expect(PiBuildModifier::RunModifier.new(workspace)).to be_a PiBuildModifier::Mapper
  end

  it 'should append lines to the 01-run.sh file' do

    #Given
    modifier = PiBuildModifier::RunModifier.new(workspace)
    FileUtils.mkdir_p File.dirname(workspace + '/' + modifier.relative_output_path)
    FileUtils.touch(workspace + '/' + modifier.relative_output_path)
    PiBuildModifier::RunModifier.append_lines.clear
    PiBuildModifier::RunModifier.append('1')
    PiBuildModifier::RunModifier.append('2')


    #When
    modifier.modify

    #Then
    expect(Pathname.new(workspace + '/' + modifier.relative_output_path)).to be_file
    expect(IO.read(Pathname.new(workspace + '/' + modifier.relative_output_path))).to eq("source #{workspace}/1\nsource #{workspace}/2\n")

  end
end

