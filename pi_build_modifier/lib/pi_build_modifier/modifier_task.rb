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

require 'pi_build_modifier/modifier/pi_modifier'
require 'pi_build_modifier/modifier/erb_mapper'
require 'pi_build_modifier/net-tweaks/wifi_network'
require 'pi_build_modifier/system/system_type'
require 'pi_build_modifier/sys_tweaks/run_modifier'
require 'pi_build_modifier/sys_tweaks/ssh'
require 'pi_build_modifier/locale/locale_debconf'
require 'pi_build_modifier/boot-files/boot'

module PiBuildModifier
  module Task

    ##
    # Modifier triggers all changes specified in the config. To this end,
    # it configures and calls specialized mappers which map the config to
    # the the individual pi-gen build scripts.

    class Modifier

      attr_reader :pi_modifier

      ##
      # Initialization and configuration of the mappers that are used to change in the pi-gen build sources

      def initialize(config, workspace, pi_modifier = PiModifier.new)
        @mappers = create_mappers
        @pi_modifier = pi_modifier
        configure_pi_modifier(config, workspace)
      end

      ##
      # Defines all mappers

      private def create_mappers
        mappers = {
            :wpa_supplicant => WPASupplicant.new,
            :system => System.new,
            :ssh => Ssh.new,
            :run_modifier => RunModifier.new,
            :locale => Locale.new,
            :boot => Boot.new
        }
        mappers[:run_modifier].append(mappers[:ssh]) #TODO: This connection has to be established somewhere else
        mappers
      end

      private def configure_pi_modifier(config, workspace)
        @pi_modifier.with_json_configuration(config)
        @mappers.each do |*, mapper_data|
          @pi_modifier.with_mapper(mapper_data.mapper(workspace))
        end
      end

      def execute
        @pi_modifier.modify
      end
    end
  end
end