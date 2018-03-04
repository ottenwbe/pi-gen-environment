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

require 'fileutils'
require 'pi_build_modifier/modifier/mapper'
require 'pi_build_modifier/sys_tweaks/run_modifier'
require 'pi_build_modifier/config/logex'

module PiBuildModifier

  class Ssh

    attr_accessor :enable

    attr_reader :template_path, :relative_output_path

    def initialize
      @enable = 'enable'
      @template_path = File.join(File.dirname(__FILE__), '/templates/ssh.sh.erb').to_s
      @relative_output_path = 'stage2/01-sys-tweaks/ssh.sh'
    end

    def mapper(workspace)
      ERBMapper.new(self, workspace)
    end

    def append_line
      "#{@relative_output_path}"
    end

    def map(json_data)
      unless json_data.nil?
        @enable = 'disable' if json_data.has_key?('ssh') && json_data['ssh'].has_key?('enabled') && (not json_data['ssh']['enabled'])
      else
        $logger.error 'Ssh could not be configured: Invalid json data.'
      end
    end

    def get_binding
      binding
    end

  end
end