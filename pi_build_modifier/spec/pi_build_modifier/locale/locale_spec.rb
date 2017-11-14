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
require 'pi_build_modifier/locale/locale_debconf'
require 'pi_build_modifier/sys_tweaks/run_modifier'
require 'pi_build_modifier/modifier/erb_mapper'
require 'pi_build_modifier/modifier/pi_modifier'


RSpec.describe PiBuildModifier::Locale do

  let(:empty_json_config) {'config_empty.json'}
  let(:json_config) {'config_full.json'}
  let(:workspace) {File.dirname(__FILE__) + '/workspace'}

  before(:each) do
    FileUtils.mkdir_p workspace
    File.open(json_config, 'w') {|file| file.write('{  "locale": {
    "gen" : ["aaa", "bbb"],
    "sys" : "ccc"
  }}')}
    File.open(empty_json_config, 'w') {|file| file.write('{}')}
  end

  after(:each) do
    FileUtils.rm(empty_json_config)
    FileUtils.rm(json_config)
    FileUtils.rm_rf workspace
  end

  # 'en_GB.UTF-8 UTF-8', 'de_DE.UTF-8 UTF-8'

  it 'should create a debconf file' do
    #Given

    modifier = PiBuildModifier::PiModifier.new
    locale = PiBuildModifier::Locale.new
    mapper = PiBuildModifier::ERBMapper.new(locale, workspace)

    #When
    modifier.with_json_configuration(json_config)
    modifier.with_mapper(mapper)
    modifier.modify

    #Then
    expect(Pathname.new(workspace + '/' + locale.relative_output_path)).to be_file
    expect(File.read(workspace + '/' + locale.relative_output_path)).to match(/aaa, bbb/)
    expect(File.read(workspace + '/' + locale.relative_output_path)).to match(/ccc/)
  end

  it 'should create a default debconf file' do
    #Given
    modifier = PiBuildModifier::PiModifier.new
    locale = PiBuildModifier::Locale.new
    mapper = PiBuildModifier::ERBMapper.new(locale, workspace)

    #When
    modifier.with_json_configuration(empty_json_config)
    modifier.with_mapper(mapper)
    modifier.modify

    #Then
    expect(Pathname.new(workspace + '/' + locale.relative_output_path)).to be_file

  end
end

