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

require 'erb'
require 'json'

module PiBuildModifier
  class Locale

    LOCALE = 'locale'

    GEN = 'gen'

    SYS = 'sys'

    attr_accessor :gen_locales, :sys_locales, :template

    attr_reader :template_path, :relative_output_path

    def initialize(gen_locales = ['en_GB.UTF-8 UTF-8'], sys_locale = 'en_GB.UTF-8')
      @gen_locales = gen_locales
      @sys_locale = sys_locale
      @template_path = File.join(File.dirname(__FILE__), '/templates/00-debconf.erb').to_s
      @relative_output_path = 'stage0/01-locale/00-debconf'
    end

    def map(json_data)
      unless json_data.nil?
        @gen_locales = json_data[LOCALE][GEN].map {|rd| rd} if json_data.has_key?(LOCALE) && json_data[LOCALE].has_key?(GEN)
        @sys_locale = json_data[LOCALE][SYS] if json_data.has_key?(LOCALE) && json_data[LOCALE].has_key?(SYS)
      end
    end

    def get_binding
      binding
    end

  end

end

