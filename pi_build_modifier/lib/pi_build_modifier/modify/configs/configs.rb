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

require 'fileutils'
require 'pi_build_modifier/modify/modifier/config_modifier'

module PiBuildModifier

  module Type
    FULL = 'full'
    LITE = 'lite'
  end

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

    def modify
      if @type.nil? || @type == Type::LITE
        make_lite
      end
    end

    private def make_lite
      directory = @workspace
      %W(#{directory}/stage3/SKIP #{directory}/stage4/SKIP #{directory}/stage5/SKIP).each do |skip_file|
        FileUtils.mkdir_p File.dirname(skip_file)
        FileUtils.touch skip_file
      end
      %W(#{directory}/stage4/EXPORT* #{directory}/stage5/EXPORT*).each do |export_file|
        FileUtils.rm_f export_file if File.exist?(export_file)
      end
    end
  end


end