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
require 'fileutils'
require 'pi_build_modifier/system/system_type'
require 'pi_build_modifier/modifier/mapper'

RSpec.describe PiBuildModifier::System do

  EXPECTED_SYSTEM_NAME = 'chiipi_test'
  EXPECTED_SYSTEM_TYPE = 'lite'
  let(:config) {{'system' => {'name' => EXPECTED_SYSTEM_NAME, 'type' => EXPECTED_SYSTEM_TYPE}}}
  let(:workspace) {"#{File.dirname(__FILE__)}/workspace"}


  after(:each) do
    FileUtils.rm_rf(workspace) if Dir.exist?(workspace)
  end


  it 'should map the name and type given in a hash to corresponding members' do
    #Given
    system = PiBuildModifier::System.new.mapper(workspace)

    #When
    system.map(config)

    #Then
    expect(system.name).to eq(EXPECTED_SYSTEM_NAME)
    expect(system.type).to eq(EXPECTED_SYSTEM_TYPE)
  end

  it 'should map the name and type to variables' do
    #Given
    system = PiBuildModifier::System.new.mapper(workspace)

    #When
    system.map(config)
    system.modify

    #Then
    %w(/config /stage3/SKIP /stage4/SKIP /stage5/SKIP).each do |file|
      expect(Pathname.new(workspace + file)).to be_file
    end
  end

end
