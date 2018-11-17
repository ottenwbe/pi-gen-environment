# Copyright (c) 2017-2018 Beate Ottenwälder
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
require 'pi_build_modifier/boot-files/boot'
require 'pi_build_modifier/modifier/erb_mapper'
require 'pi_build_modifier/modifier/pi_modifier'

RSpec.describe PiBuildModifier::Boot do

  let(:empty_json_config) {'config_empty.json'}
  let(:full_json_config) {'config_full.json'}
  let(:disabled_json_config) {'config_disabled.json'}
  let(:workspace) {File.dirname(__FILE__) + '/workspace_boot'}

  before(:each) do
    FileUtils.mkdir_p workspace
    File.open(full_json_config, 'w') {|file| file.write('{  "cgroups": {
    "memory" : true
  }}')}
    File.open(disabled_json_config, 'w') {|file| file.write('{  "cgroups": {
    "memory" : false
  }}')}
    File.open(empty_json_config, 'w') {|file| file.write('{}')}
  end

  after(:each) do
    FileUtils.rm(empty_json_config)
    FileUtils.rm(full_json_config)
    FileUtils.rm(disabled_json_config)
    FileUtils.rm_rf workspace
  end

  it 'should create a cmdline.txt file with all cgroups enabled when they are specified in the resources.json' do
    #Given
    modifier = PiBuildModifier::PiModifier.new
    boot = PiBuildModifier::Boot.new
    mapper = PiBuildModifier::ERBMapper.new(boot, workspace)

    #When
    modifier.with_json_configuration(full_json_config)
    modifier.with_mapper(mapper)
    modifier.modify

    #Then
    expect(Pathname.new(workspace + '/' + boot.relative_output_path)).to be_file
    expect(File.read(workspace + '/' + boot.relative_output_path)).to match(/ cgroup_memory=1 /)
  end

  it 'should create a cmdline.txt file without cgroups enabled when they are disabled in the resources.json' do
    #Given
    modifier = PiBuildModifier::PiModifier.new
    boot = PiBuildModifier::Boot.new
    mapper = PiBuildModifier::ERBMapper.new(boot, workspace)

    #When
    modifier.with_json_configuration(disabled_json_config)
    modifier.with_mapper(mapper)
    modifier.modify

    #Then
    expect(Pathname.new(workspace + '/' + boot.relative_output_path)).to be_file
    expect(File.read(workspace + '/' + boot.relative_output_path)).to_not match(/ cgroup_memory=1 /)

  end

  it 'should create a cmdline.txt file without cgroups enabled when they are not specified' do
    #Given
    modifier = PiBuildModifier::PiModifier.new
    boot = PiBuildModifier::Boot.new
    mapper = PiBuildModifier::ERBMapper.new(boot, workspace)

    #When
    modifier.with_json_configuration(empty_json_config)
    modifier.with_mapper(mapper)
    modifier.modify

    #Then
    expect(Pathname.new(workspace + '/' + boot.relative_output_path)).to be_file
    expect(File.read(workspace + '/' + boot.relative_output_path)).to_not match(/ cgroup_memory=1 /)

  end
end

