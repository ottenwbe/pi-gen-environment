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
require 'pi_customizer/modify/modifiers'
require 'pi_customizer/modify/configs/configs'


RSpec.describe PiCustomizer::Modifiers do

  context 'ModifiersBuilder' do

    it 'creates Modifiers' do
      modifier = PiCustomizer::Modifiers::ModifiersBuilder::build_defaults(".", "no.cfg")
      expect(modifier.config_modifiers).not_to be_nil
      expect(modifier.config_modifiers).not_to be_a PiCustomizer::Modifiers::Modifiers
    end

    it 'creates and adds erb and config file modifiers to the Modifiers' do
      modifier = PiCustomizer::Modifiers::ModifiersBuilder::build_defaults("no.cfg", ".")
      expect(modifier.config_modifiers).to include(be_a PiCustomizer::Modifiers::ERBConfigModifier)
      expect(modifier.config_modifiers).to include(be_a PiCustomizer::Modifiers::ConfigFileModifier)
    end

  end

  context 'Modifiers' do

    let(:tmp_cfg_file) {'tmp.json'}

    before(:each) do
      File.open(tmp_cfg_file, 'w') {|file| file.write('{"cgroups": {"memory" : true}}')}
    end

    after(:each) do
      FileUtils.rm_rf tmp_cfg_file
    end

    it 'holds configuration modifiers' do
      modifiers = PiCustomizer::Modifiers::Modifiers.new
      modifiers.with_config_modifier(PiCustomizer::Modifiers::ConfigModifier.new("."))
      expect(modifiers.config_modifiers).to include(be_a PiCustomizer::Modifiers::ConfigModifier)
    end

    it 'reads configurations from files' do
      modifiers = PiCustomizer::Modifiers::Modifiers.new
      modifiers.with_json_configuration(tmp_cfg_file).modify_configs
      expect(modifiers.json_data.has_key?('cgroups')).to be true
    end

    it 'triggers checks of the configuration modifiers' do
      test_modifier = PiCustomizer::Modifiers::ConfigModifier.new(".")
      expect(test_modifier).to receive(:check)
      modifiers = PiCustomizer::Modifiers::Modifiers.new
      modifiers.with_config_modifier(test_modifier).with_json_configuration(tmp_cfg_file).modify_configs
    end

    it 'triggers verifications of the configuration modifiers' do
      test_modifier = PiCustomizer::Modifiers::ConfigModifier.new(".")
      expect(test_modifier).to receive(:verify)
      modifiers = PiCustomizer::Modifiers::Modifiers.new
      modifiers.with_config_modifier(test_modifier).with_json_configuration(tmp_cfg_file).modify_configs
    end

    it 'triggers mappings of the configuration modifiers' do
      test_modifier = PiCustomizer::Modifiers::ConfigModifier.new(".")
      expect(test_modifier).to receive(:map)
      modifiers = PiCustomizer::Modifiers::Modifiers.new
      modifiers.with_config_modifier(test_modifier).with_json_configuration(tmp_cfg_file).modify_configs
    end

    it 'triggers modifications of the configuration modifiers' do
      test_modifier = PiCustomizer::Modifiers::ConfigModifier.new(".")
      expect(test_modifier).to receive(:modify)
      modifiers = PiCustomizer::Modifiers::Modifiers.new
      modifiers.with_config_modifier(test_modifier).with_json_configuration(tmp_cfg_file).modify_configs
    end

    it 'triggers finishing steps of the configuration modifiers' do
      test_modifier = PiCustomizer::Modifiers::ConfigModifier.new(".")
      expect(test_modifier).to receive(:finish)
      modifiers = PiCustomizer::Modifiers::Modifiers.new
      modifiers.with_json_configuration(tmp_cfg_file).with_config_modifier(test_modifier).modify_configs
    end

  end

  context 'SystemConfig' do
    it 'handle the name config' do
      configuration = PiCustomizer::Configs::SystemConfig.new
      configuration.map(JSON.parse '{"system": {"name" : "test"}}')
      expect(configuration.name).to eq('test')
    end
    it 'handle the name config' do
      configuration = PiCustomizer::Configs::SystemConfig.new
      configuration.map(JSON.parse '{"system": {"username" : "user", "password" : "pwd"}}')
      expect(configuration.username).to eq('user')
      expect(configuration.password).to eq('pwd')
    end
    it 'returns the config change w/o  username and password' do
      configuration = PiCustomizer::Configs::SystemConfig.new
      configuration.map(JSON.parse '{"system": {"name" : "test"}}')
      expect(configuration.config_line).to eq("IMG_NAME='test'")
    end
    it 'returns the config change w/  username and password' do
      configuration = PiCustomizer::Configs::SystemConfig.new
      configuration.map(JSON.parse '{"system": {"username" : "user", "password" : "pwd"}}')
      expect(configuration.config_line).to eq("IMG_NAME='custompi'\nFIRST_USER_NAME=user\nFIRST_USER_PASS=pwd")
    end
    it 'ensures that a name for the image is provided' do
      configuration = PiCustomizer::Configs::SystemConfig.new
      configuration.map(JSON.parse '{"system": {"name" : ""}}')
      expect {configuration.verify}.to raise_error("No valid image name string provided in the config file! E.g., it might be an empty string or not a string at all. Configured image name: ''.")
    end
    it 'ensures that the name for the image ca' do
      configuration = PiCustomizer::Configs::SystemConfig.new
      configuration.map(JSON.parse '{"system": {"name" : 1234}}')
      expect {configuration.verify}.to raise_error("No valid image name string provided in the config file! E.g., it might be an empty string or not a string at all. Configured image name: '1234'.")
    end
  end

  context 'SshConfig' do
    it 'handle the ssh config' do
      configuration = PiCustomizer::Configs::SshConfig.new
      configuration.map(JSON.parse '{"ssh": {"enable" : true}}')
      expect(configuration.enable).to be_truthy
    end
    it 'returns the config change' do
      configuration = PiCustomizer::Configs::SshConfig.new
      configuration.map(JSON.parse '{"ssh": {"enable" : true}}')
      expect(configuration.config_line).to eq("ENABLE_SSH=1")
    end
  end

  context 'Boot' do

    let(:empty_json_config) {JSON.parse '{}'}
    let(:json_config) {JSON.parse '{ "cgroups": { "memory" : true }}'}
    let(:disabled_json_config) {JSON.parse '{ "cgroups": { "memory" : false }}'}
    let(:workspace) {File.join(File.dirname(__FILE__), '/workspace_boot')}

    before(:each) do
      FileUtils.mkdir_p workspace
    end

    after(:each) do
      FileUtils.rm_rf workspace
    end

    it 'should create a cmdline.txt file with all cgroups enabled when they are specified' do
      modifier = PiCustomizer::Modifiers::ERBConfigModifier.new(workspace)
      config = PiCustomizer::Configs::Boot.new
      modifier.add(config)
      modifier.map(json_config)
      modifier.modify
      expect(Pathname.new(File.join(workspace, config.relative_output_path))).to be_file
      expect(File.read(File.join(workspace, config.relative_output_path))).to match(/ cgroup_memory=1 /)
    end

    it 'should create a cmdline.txt file without cgroups enabled when they are disabled' do
      modifier = PiCustomizer::Modifiers::ERBConfigModifier.new(workspace)
      config = PiCustomizer::Configs::Boot.new
      modifier.add(config)
      modifier.map(disabled_json_config)
      modifier.modify
      expect(Pathname.new(File.join(workspace, config.relative_output_path))).to be_file
      expect(File.read(File.join(workspace, config.relative_output_path))).to_not match(/ cgroup_memory=1 /)
    end

    it 'should NOT create a cmdline.txt file without cgroups enabled when they are not specified' do
      modifier = PiCustomizer::Modifiers::ERBConfigModifier.new(workspace)
      config = PiCustomizer::Configs::Boot.new
      modifier.add(config)
      modifier.map(empty_json_config)
      modifier.modify
      expect(Pathname.new(File.join(workspace, config.relative_output_path))).to_not be_file
    end
  end

  context 'Packages' do

    let(:packages_config) {JSON.parse '{ "packages": ["vim","less"] }'}
    let(:invalid_config) {JSON.parse '{ "packages": { "foo" : "test" } }'}
    let(:workspace) {File.join(File.dirname(__FILE__), '/workspace_packages')}

    before(:each) do
      FileUtils.mkdir_p workspace
    end

    after(:each) do
      FileUtils.rm_rf workspace
    end

    it 'creates a packages stage' do
      modifier = PiCustomizer::Modifiers::ConfigFileModifier.new(workspace)
      config = PiCustomizer::Configs::Packages.new
      modifier.add(config)
      modifier.map(packages_config)
      modifier.modify

      expect(Pathname.new(File.join(workspace, '/stage_build'))).to be_directory
    end

    it 'creates a prerun.sh' do
      modifier = PiCustomizer::Modifiers::ConfigFileModifier.new(workspace)
      config = PiCustomizer::Configs::Packages.new
      modifier.add(config)
      modifier.map(packages_config)
      modifier.modify
      modifier.verify

      expect(Pathname.new(File.join(workspace, '/stage_build/prerun.sh'))).to be_file
    end

    it 'verifies that packages are provided as an array in the config file' do
      modifier = PiCustomizer::Modifiers::ConfigFileModifier.new(workspace)
      config = PiCustomizer::Configs::Packages.new
      modifier.add(config)
      modifier.map(invalid_config)

      expect {modifier.verify}.to raise_error
    end


    it 'writes the packages specified int the configuration to a file' do
      modifier = PiCustomizer::Modifiers::ConfigFileModifier.new(workspace)
      config = PiCustomizer::Configs::Packages.new
      modifier.add(config)
      modifier.map(packages_config)
      modifier.modify

      expect(File.read(File.join(workspace, '/stage_build/00-install-packages/00-packages'))).to eq("vim\nless\n")
    end

  end

  context 'Type' do

    let(:json_config) {JSON.parse '{ "system": { "type" : "lite" }}'}
    let(:invalid_json_config) {JSON.parse '{ "system": { "type" : "image" }}'}
    let(:workspace) {File.join(File.dirname(__FILE__), '/workspace_boot')}

    before(:each) do
      FileUtils.mkdir_p workspace
    end

    after(:each) do
      FileUtils.rm_rf workspace
    end

    it 'ensures that a valid type is specified' do
      modifier = PiCustomizer::Modifiers::ConfigModifier.new(workspace)
      config = PiCustomizer::Configs::TypeConfig.new
      modifier.add(config)
      modifier.map(invalid_json_config)
      modifier.modify

      expect {modifier.verify}.to raise_error
    end

    it 'should create skip files' do
      modifier = PiCustomizer::Modifiers::ConfigModifier.new(workspace)
      config = PiCustomizer::Configs::TypeConfig.new
      modifier.add(config)
      modifier.map(json_config)
      modifier.modify

      expect(Pathname.new(File.join(workspace, '/stage3/SKIP'))).to be_file
      expect(Pathname.new(File.join(workspace, '/stage4/SKIP'))).to be_file
      expect(Pathname.new(File.join(workspace, '/stage5/SKIP'))).to be_file
    end

  end

  context 'WiFi' do
    let(:empty_json_config) {JSON.parse '{}'}
    let(:json_config) {JSON.parse '{"wifi" : { "wpa_country" : "DE_test", "networks": [{ "ssid": "test_wpsk", "wpsk": "test_wpsk" }]}}'}
    let(:workspace) {File.dirname(__FILE__) + '/workspace'}

    before do
      FileUtils.mkdir_p workspace
    end

    after do
      FileUtils.rm_rf workspace
    end

    it 'should create a default wpa_supplicant.config when no change is specified in the json configuration file' do
      modifier = PiCustomizer::Modifiers::ERBConfigModifier.new(workspace)
      config = PiCustomizer::Configs::Wifi.new
      modifier.add(config)
      modifier.map(json_config)
      modifier.modify
      expect(Pathname.new(File.join(workspace, config.relative_output_path))).to be_file
    end

    it 'should create a wpa_supplicant.config with all changes that are specified in the json configuration file' do
      modifier = PiCustomizer::Modifiers::ERBConfigModifier.new(workspace)
      config = PiCustomizer::Configs::Wifi.new
      modifier.add(config)
      modifier.map(json_config)
      modifier.modify

      wpa_supplicant_file = File.read(File.join(workspace, config.relative_output_path))
      expect(wpa_supplicant_file).to match(/network/)
    end
  end

  context 'Locales' do
    let(:empty_json_config) {JSON.parse '{}'}
    let(:json_config) {JSON.parse '{  "locale": { "gen" : ["aaa", "bbb"], "sys" : "ccc" }}'}
    let(:workspace) {File.join(File.dirname(__FILE__), '/workspace')}

    before(:each) do
      FileUtils.mkdir_p workspace
    end

    after(:each) do
      FileUtils.rm_rf workspace
    end

    it 'should create a debconf file' do
      modifier = PiCustomizer::Modifiers::ERBConfigModifier.new(workspace)
      config = PiCustomizer::Configs::Locale.new
      modifier.add(config)
      modifier.map(json_config)
      modifier.modify

      expect(Pathname.new(File.join(workspace, config.relative_output_path))).to be_file
      expect(File.read(File.join(workspace, config.relative_output_path))).to match(/aaa, bbb/)
      expect(File.read(File.join(workspace, config.relative_output_path))).to match(/ccc/)
    end

    it 'should NOT create a default debconf file' do
      modifier = PiCustomizer::Modifiers::ERBConfigModifier.new(workspace)
      config = PiCustomizer::Configs::Locale.new
      modifier.add(config)
      modifier.map(empty_json_config)
      modifier.modify

      expect(Pathname.new(File.join(workspace, config.relative_output_path))).to_not be_file
    end
  end

end
