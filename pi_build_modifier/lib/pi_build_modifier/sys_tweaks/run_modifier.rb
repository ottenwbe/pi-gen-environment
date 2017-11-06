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

  class RunModifier < Mapper

    attr_reader :relative_output_path

    @@append_lines = Array.new
    def self.append_lines
      @@append_lines
    end

    def initialize(workspace)
      @workspace = workspace
      @relative_output_path = 'stage2/01-sys-tweaks/01-run.sh'
    end

    def self.append(append_line)
      @@append_lines << append_line
    end

    def map(json_data)
    end

    def modify
      puts @@append_lines.to_s
      open("#{@workspace}/#{@relative_output_path}", 'a') do |f|
        @@append_lines.each do |a|
          f.puts "source #{@workspace}/#{a}"
        end
      end
    end

  end
end