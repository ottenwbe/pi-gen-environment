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

module PiBuildModifier
  class PiModifier

    attr_reader :mappers

    def initialize
      @mappers = Array.new
      @json_path = nil
      @json_data = nil
    end

    def with_json_configuration(json_file)
      @json_path = json_file
    end

    def with_mapper(mapper)
      if mapper.is_a? Mapper
        @mappers << mapper
      else
        raise 'Parameter must be of type Mapper'
      end
    end

    def modify(do_check = false)
      load_config
      check_all if do_check
      map_all
      modify_all
    end

    private def load_config
      if File.file?(@json_path)
        File.open(@json_path, 'r+') do |f|
          @json_data = JSON.parse(f.read)
        end
      else
        raise "Json configuration file does not exist at '#{@json_path}!'"
      end
    end

    private def check_all
      @mappers.each do |mapper|
        mapper.check(@json_data)
      end
    end

    private def map_all
      @mappers.each do |mapper|
        mapper.map(@json_data)
      end
    end

    private def modify_all
      @mappers.each do |mapper|
        mapper.modify
      end
    end
  end
end