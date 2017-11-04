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

require 'pi_build_modifier/modifier/pi_modifier'
require 'pi_build_modifier/modifier/erb_mapper'
require 'pi_build_modifier/net-tweaks/wifi_network'
require 'pi_build_modifier/system/system_type'
require 'pi_build_modifier/sys_tweaks/run_modifier'
require 'pi_build_modifier/sys_tweaks/ssh'

module PiBuildModifier
  module Task
    class Modifier

      attr_reader :pi_modifier

      def initialize(config, workspace, pi_modifier = PiModifier.new)
        @pi_modifier = pi_modifier
        @pi_modifier.with_json_configuration(config)

        @pi_modifier.with_mapper(ERBMapper.new(WPASupplicant.new, workspace))
        @pi_modifier.with_mapper(System.new(workspace))
        @pi_modifier.with_mapper(ERBMapper.new(Ssh.new, workspace))
        @pi_modifier.with_mapper(RunModifier.new(workspace))
      end

      def execute
        @pi_modifier.modify
      end
    end
  end
end