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

module PiBuildModifier
  class Modifiers

    attr_reader :config_modifiers

    def initialize
      @config_modifiers = Array.new
      @json_path = nil
      @json_data = nil
    end

    def with_json_configuration(json_file)
      @json_path = json_file
      self
    end

    def with_config_modifier(config_modifier)
      if config_modifier.is_a? ConfigModifier
        @config_modifiers << config_modifier
      else
        raise 'Parameter must be of type "ConfigModifier"'
      end
      self
    end

    def modify_configs
      load_config
      check_all
      map_all
      modify_all
      finish_all
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
      @config_modifiers.each(&:check)
    end

    private def map_all
      @config_modifiers.each do |mapper|
        mapper.map(@json_data)
      end
    end

    private def modify_all
      @config_modifiers.each(&:modify)
    end

    private def finish_all
      @config_modifiers.each(&:finish)
    end

  end
end