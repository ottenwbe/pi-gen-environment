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

require 'json'
require 'pathname'
require 'fileutils'
require 'pi_build_modifier/modifier/mapper'

module PiBuildModifier
  class ERBMapper < Mapper

    def initialize(data, working_dir)
      if data.nil?
        raise 'Cannot initialize ERBMapper, since no valid object for mapping is given.'
      end
      @data = data
      @template_path = @data.template_path
      @output_path = working_dir + '/' + @data.relative_output_path
    end

    def check(json_data)
      @data.check(json_data)
    end

    def map(json_data)
      @data.map(json_data)
    end

    def modify
      read_template
      create_conf
    end

    private def read_template
      File.open(@template_path.to_s, 'r+') do |f|
        @template = f.read
      end
    end

    def render
      ERB.new(@template).result(@data.get_binding)
    end

    private def create_conf

      puts "create dir at #{@output_path}"

      FileUtils.mkdir_p File.dirname @output_path

      File.open(@output_path, 'w+') do |f|
        f.write(render)
      end
    end
  end
end