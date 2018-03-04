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

require 'thor'
require 'pi_build_modifier/net-tweaks/wifi_network'
require 'pi_build_modifier/modifier/erb_mapper'
require 'pi_build_modifier/version'
require 'pi_build_modifier/modifier_task'
require 'pi_build_modifier/config/logex'

module PiBuildModifier

  ##
  # PiBuildModifier implements all cli commands of pi_build_modifier.

  class PiBuildModifier < Thor

    desc 'modify CONFIG WORKSPACE', 'Modify the pi image sources at the specified WORKSPACE with the specified configuration file CONFIG.'
    def modify(config, workspace)
      $logger.debug "Modifying with a configuration read from '#{config}' in the workspace '#{workspace}'"
      task = Task::Modifier.new(config, workspace)
      task.execute
    end

    ##
    # The version command allows users to query for the current version of the pi_customizer gem. It is printed on the command line.

    desc 'v, version', 'Show the version of the modifier.'
    def version
      puts VERSION
    end
  end
end
