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

module PiBuildModifier

  module Type
    FULL = 'full'
    LITE = 'lite'
  end

  class System < Mapper

    attr_reader :name, :type

    def initialize(workspace)
      @workspace = workspace
      @name = 'custompi'
      @type = Type::FULL
      @relative_output_path = @workspace
    end

    def map(json_data)
      unless json_data.nil?
        @name = json_data['system']['name'] if json_data.has_key?('system') && json_data['system'].has_key?('name')
        @type = json_data['system']['type'] if json_data.has_key?('system') && json_data['system'].has_key?('type')
      else
        # TODO: log error
      end
    end

    def modify
      write_name
      modify_type
    end

    private def modify_type
      if @type.nil? || @type == Type::LITE
        make_lite
      end
    end

    private def write_name
      FileUtils.mkdir_p "#{@workspace}"
      File.open("#{@workspace}/config", 'w') do |file|
        file.write("IMG_NAME='#{@name}'")
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