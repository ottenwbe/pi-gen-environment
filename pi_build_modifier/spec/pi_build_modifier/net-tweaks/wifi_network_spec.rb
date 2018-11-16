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
require 'pi_build_modifier/net-tweaks/wifi_network'
require 'pi_build_modifier/modifier/erb_mapper'
require 'pi_build_modifier/modifier/pi_modifier'


RSpec.describe PiBuildModifier::WPASupplicant do

  let(:empty_json_config) {'config_empty.json'}
  let(:json_config) {'config_full.json'}
  let(:workspace) {File.dirname(__FILE__) + '/workspace'}

  before do
    FileUtils.mkdir_p workspace
    File.open(empty_json_config, 'w') {|file| file.write('{}')}
    File.open(json_config, 'w') {|file| file.write(' {"wifi" : {
    "wpa_country" : "DE_test",
    "networks": [
      {
        "ssid": "test_wpsk",
        "wpsk": "test_wpsk"
      }
    ]
  }
}
')}
  end

  after do
    FileUtils.rm(empty_json_config)
    FileUtils.rm(json_config)
    FileUtils.rm_rf workspace
  end

  it 'should create a default wpa_supplicant.config when no change is specified in the json configuration file' do

    #Given
    modifier = PiBuildModifier::PiModifier.new
    wpa_supplicant = PiBuildModifier::WPASupplicant.new
    mapper = PiBuildModifier::ERBMapper.new(wpa_supplicant, workspace)

    #When
    modifier.with_json_configuration(empty_json_config)
    modifier.with_mapper(mapper)
    modifier.modify

    #Then
    expect(Pathname.new(workspace + '/' + wpa_supplicant.relative_output_path)).to be_file
  end

  it 'should create a wpa_supplicant.config with all changes that are specified in the json configuration file' do

    #Given
    modifier = PiBuildModifier::PiModifier.new
    wpa_supplicant = PiBuildModifier::WPASupplicant.new
    mapper = wpa_supplicant.mapper(workspace)

    #When
    modifier.with_json_configuration(json_config)
    modifier.with_mapper(mapper)
    modifier.modify

    #Then
    wpa_supplicant_file = File.read(workspace + '/' + wpa_supplicant.relative_output_path)
    expect(wpa_supplicant_file).to match(/network/)
  end

end

