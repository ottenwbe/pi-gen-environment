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
  class WifiNetwork

    attr_accessor :ssid, :psk, :template

    attr_reader :file

    def initialize(ssid = 'no_ssid', psk = 'no_psk')
      @ssid = ssid
      @psk = psk
      @file = 'wpa_supplicant.conf.erb'
    end

    def to_s
      sprintf('{
        ssid="%s"
        psk="%s"
}', ssid, psk)
    end
  end

  class WPASupplicant

    attr_reader :template_path, :relative_output_path

    def initialize(networks = Array.new(0), wpa_country = 'DE')
      @networks = networks
      @wpa_country = wpa_country
      @template_path = File.join(File.dirname(__FILE__), '/../templates/wpa_supplicant.conf.erb').to_s
      @relative_output_path = 'stage2/02-net-tweaks/wpa_supplicant.conf'
    end

    def map(json_data)
      @networks = json_data['networks'].map {|rd| WifiNetwork.new(rd['ssid'], rd['wpsk'])} if json_data.has_key? 'networks'
      @wpa_country = json_data['wpa_country'] if json_data.has_key? 'wpa_country'
    end

    def get_binding
      binding
    end

  end
end

