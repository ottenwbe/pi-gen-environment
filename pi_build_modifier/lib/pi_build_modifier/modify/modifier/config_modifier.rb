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

require 'pi_build_modifier/utils/logex'

module PiBuildModifier

  ##
  # ConfigModifier represents a container that is used by the pi_build_modifier to call
  # the necessary steps to modify a build configuration.
  # It triggers check, mapping, and modification steps for one build configuration.

  class ConfigModifier

    def initialize(workspace)
      @workspace = workspace
      @configs = Array.new
    end

    def add(config)
      @configs << config
    end

    def check
      @configs.each {|config| config.check unless config.nil?}
    end

    def map(json_data)
      @configs.each {|config| config.map(json_data) unless config.nil?}
    end

    def modify
      @configs.each {|config| config.modify unless config.nil?}
    end

    def finish
      $logger.debug("Skipped finish")
    end

  end
end