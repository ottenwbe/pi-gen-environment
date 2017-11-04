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
require 'fileutils'
require 'pi_customizer/version'
require 'pi_customizer/environment/environment_builder_factory'

module PiCustomizer
  class PiCustomizer < Thor
    desc 'build ENV', 'Build pi image on environment ENV (options are AWS or VAGRANT).'
    option :git_path
    option :workspace
    option :config_file
    option :tmp_folder
    def build(env)
      begin
        builder = Environment::environment_builder_factory(env, "#{options[:git_path]}", "#{options[:workspace]}", "#{options[:config_file]}", "#{options[:tmp_folder]}")
        builder.build
      rescue Exception => e
        $logger.error e.message
      end
    end

    desc 'version', 'Shows the version number.'
    def version
      puts VERSION
    end
  end
end