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
    expect(PiBuildModifier::RunModifier.new).to be_a PiBuildModifier::Mapper
  end

  it 'should append lines to the 01-run.sh file' do

    #Given
    modifier = PiBuildModifier::RunModifier.new.mapper(workspace)
    FileUtils.mkdir_p File.dirname(workspace + '/' + modifier.relative_output_path)
    FileUtils.touch(workspace + '/' + modifier.relative_output_path)
    modifier.append(Class.new do
      def append_line
        '1'
      end
    end.new
    )
    modifier.append(Class.new do
      def append_line
        '2'
      end
    end.new
    )


    #When
    modifier.modify

    #Then
    expect(Pathname.new(workspace + '/' + modifier.relative_output_path)).to be_file
    expect(IO.read(Pathname.new(workspace + '/' + modifier.relative_output_path))).to match(/\nsource #{workspace}\/1\nsource #{workspace}\/2\n/)

  end

end

