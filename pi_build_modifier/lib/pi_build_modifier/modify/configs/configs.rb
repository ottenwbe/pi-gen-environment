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

require 'json'
require 'openssl'
require 'pi_build_modifier/utils/logex'

module PiBuildModifier
  module Configs

    def Configs.create_config_modifiers
      [TypeConfig.new]
    end

    def Configs.create_erb_modifiers
      [Locale.new, Boot.new]
    end

    def Configs.create_config_file_modifiers
      [NameConfig.new, SshConfig.new, Wifi.new]
    end

    ######################## Config File Modifiers (ConfigFileModifier) ########################

    class NameConfig

      attr_reader :name, :type

      def initialize
        @name = 'custompi'
      end

      def check
        true
      end

      def map(json_data)
        unless json_data.nil?
          @name = json_data['system']['name'] if json_data.has_key?('system') && json_data['system'].has_key?('name')
        else
          $logger.error "No json configuration found"
        end
      end

      def config_line
        "IMG_NAME='#{@name}'"
      end
    end

    class SshConfig

      def initialize
        @enable = true
      end

      def check
        true
      end

      def map(json_data)
        unless json_data.nil?
          @enable = json_data['ssh']['enabled'] if json_data.has_key?('ssh') && json_data['ssh'].has_key?('enabled')
        else
          $logger.error 'Ssh could not be configured: Invalid json data.'
        end
      end

      def config_line
        if @enable
          "ENABLE_SSH=1"
        end
      end
    end

    ##
    # Wifi represents the wpa_supplicant's configuration

    class Wifi

      PASSPHRASE = 'passphrase'

      WPA_PASSPHRASE = 'wpa_passphrase'

      SSID = 'ssid'


      def initialize
        @networks = map_network(nil)
        @wpa_country = 'DE'
      end

      def check
        true
      end

      #    def check(json_data)
      #      unless File.file?(@relative_output_path)
      #        raise "File #{relative_output_path} does not exist"
      #      end
      #    end

      ##
      # map the 'wifi' section in the json configuration to the instance variables.

      def map(json_data)
        unless json_data.nil?
          @networks = map_network(json_data['wifi']) if json_data.has_key?('wifi')
          @wpa_country = json_data['wifi']['wpa_country'] if json_data.has_key?('wifi') && json_data['wifi'].has_key?('wpa_country')
        else
          $logger.warn("Could not map wifi config due to missing Json")
        end
      end

      private def map_network(json_data)
        if json_data.nil? or not json_data.has_key?('networks')
          networks = Array.new(0)
        else
          networks = json_data['networks'].map do |rd|
            ssid = if rd.has_key?(SSID)
                     rd[SSID]
                   else
                     'no_ssid'
                   end
            psk = if rd.has_key?(PASSPHRASE)
                    OpenSSL::PKCS5.pbkdf2_hmac_sha1(rd[PASSPHRASE], ssid, 4096, 32).unpack("H*").first
                  elsif rd.has_key?(WPA_PASSPHRASE)
                    rd[WPA_PASSPHRASE]
                  else
                    'no_psk'
                  end
            WifiNetwork.new(ssid, psk)
          end
        end
        networks
      end

      def config_line
        result = "WPA_COUNTRY=#{@wpa_country}"
        unless @networks.length == 0
          result = "#{result}\nWPA_PASSWORD=#{@networks[0].psk}\nWPA_ESSID=#{@networks[0].ssid}"
        end
        result
      end

    end

    ######################## ERB Modifiers (ERBConfigModifier) ########################

    ##
    # The Locale class is used to customize the locales

    class Locale

      LOCALE = 'locale'

      GEN = 'gen'

      SYS = 'sys'

      attr_accessor :gen_locales, :sys_locales

      attr_reader :template_path, :relative_output_path

      def initialize(gen_locales = ['en_GB.UTF-8 UTF-8'], sys_locale = 'en_GB.UTF-8')
        @gen_locales = gen_locales
        @sys_locale = sys_locale
        @template_path = File.join(File.dirname(__FILE__), '/templates/00-debconf.erb').to_s
        @relative_output_path = 'stage0/01-locale/00-debconf'
      end

      def check
        true
      end

      def map(json_data)
        unless json_data.nil?
          @gen_locales = json_data[LOCALE][GEN].map {|gen| gen} if json_data.has_key?(LOCALE) && json_data[LOCALE].has_key?(GEN)
          @sys_locale = json_data[LOCALE][SYS] if json_data.has_key?(LOCALE) && json_data[LOCALE].has_key?(SYS)
        end
      end

      def get_binding
        binding
      end

    end


    ##
    # The Locale class is used to customize locales

    class Boot

      C_GROUPS = 'cgroups'

      C_GROUP_MEMORY = 'memory'

      attr_accessor :c_groups

      attr_reader :template_path, :relative_output_path

      def initialize(c_groups = [''])
        @c_groups = c_groups
        @template_path = File.join(File.dirname(__FILE__), '/templates/07-resize-init.diff.erb').to_s
        @relative_output_path = 'stage2/01-sys-tweaks/00-patches/07-resize-init.diff'
      end

      def check
        true
      end

      def map(json_data)
        unless json_data.nil? || !json_data.has_key?(C_GROUPS)
          if json_data[C_GROUPS].has_key?(C_GROUP_MEMORY) && json_data[C_GROUPS][C_GROUP_MEMORY]
            @c_groups << 'cgroup_enable=memory cgroup_memory=1 swapaccount=1'
          end
        end
      end

      def get_binding
        binding
      end

    end

    ######################## Config Modifiers (ConfigModifier) ########################

    module Type
      FULL = 'full'
      LITE = 'lite'
    end

    class TypeConfig

      def initialize
        @type = Type::FULL
      end

      def check
        true
      end

      def map(json_data)
        unless json_data.nil?
          @type = json_data['system']['type'] if json_data.has_key?('system') && json_data['system'].has_key?('type')
        else
          $logger.error "No json configuration found"
        end
      end

      def modify(workspace)
        if @type.nil? || @type == Type::LITE
          make_lite(workspace)
        end
      end

      private def make_lite(workspace)
        %W(#{workspace}/stage3/SKIP #{workspace}/stage4/SKIP #{workspace}/stage5/SKIP).each do |skip_file|
          FileUtils.mkdir_p File.dirname(skip_file)
          FileUtils.touch skip_file
        end
        %W(#{workspace}/stage4/EXPORT* #{workspace}/stage5/EXPORT*).each do |export_file|
          FileUtils.rm_f export_file if File.exist?(export_file)
        end
      end
    end

    ######################## Helper ########################

    class WifiNetwork
      attr_reader :ssid, :psk

      def initialize(ssid, psk)
        @ssid = ssid
        @psk = psk
      end
    end

  end
end