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
require 'openssl'
require 'pi_build_modifier/modifier/erb_mapper'

module PiBuildModifier
  class WifiNetwork

    attr_reader :ssid, :psk

    def initialize(ssid, psk)
      @ssid = ssid
      @psk = psk
    end

    def to_s
      sprintf('{
  ssid="%s"
  psk=%s
}', ssid, psk)
    end
  end

  class WPASupplicant

    PASSKEY = 'passphrase'

    WPA_PASSKEY = 'wpa_passphrase'

    SSID = 'ssid'

    attr_reader :template_path, :relative_output_path

    def initialize
      @networks = map_network(nil)
      @wpa_country = 'DE'
      @template_path = File.join(File.dirname(__FILE__), '/templates/wpa_supplicant.conf.erb').to_s
      @relative_output_path = 'stage2/02-net-tweaks/files/wpa_supplicant.conf'
    end

    def mapper(workspace)
      ERBMapper.new(self, workspace)
    end

    def map(json_data)
      unless json_data.nil?
        @networks = map_network(json_data['wifi']) if json_data.has_key?('wifi')
        @wpa_country = json_data['wifi']['wpa_country'] if json_data.has_key?('wifi') && json_data['wifi'].has_key?('wpa_country')
      end
    end

    private def map_network(json_data)
      if json_data.nil?
        networks = Array.new(0)
      else
        networks = json_data['networks'].map do |rd|
          ssid = if rd.has_key?(SSID)
                   rd[SSID]
                 else
                   'no_ssid'
                 end
          psk = if rd.has_key?(PASSKEY)
                  OpenSSL::PKCS5.pbkdf2_hmac_sha1(rd[PASSKEY], ssid, 4096, 32).unpack("H*").first
                elsif rd.has_key?(WPA_PASSKEY)
                  rd[WPA_PASSKEY]
                else
                  'no_psk'
                end
          WifiNetwork.new(ssid, psk)
        end
      end
      networks
    end

    def get_binding
      binding
    end

  end
end

