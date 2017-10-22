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

require 'rspec'
require_relative '../../lib/pi_build_modifier/net-tweaks/WifiNetwork'
require_relative '../../lib/pi_build_modifier/mapper/mapper'
require 'FileUtils'

module PiBuildModifier
  RSpec.describe WPASupplicant do

    let(:empty_json_config) {'config_empty.json'}

    before(:each) do
      File.open(empty_json_config, 'w') {|file| file.write('{}')}
    end

    after(:each) do
      FileUtils.rm(empty_json_config)
    end

    it 'should create a default "WPAsupplication".conf ' do

      #Given
      wpaSupplicant = WPASupplicant.new
      mapper = Mapper.new(wpaSupplicant, empty_json_config, File.dirname(__FILE__))

      #When
      mapper.do_map

      #Then
      expect(Pathname.new(File.dirname(__FILE__) + '/' + wpaSupplicant.relative_output_path)).to be_file

      #After
      FileUtils.rm File.dirname(__FILE__) + '/' + wpaSupplicant.relative_output_path
    end
  end

end
