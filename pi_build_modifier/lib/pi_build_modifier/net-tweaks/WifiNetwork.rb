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

    def initialize(stage_path = '', networks = Array.new(0), wpa_country = 'DE')
      @stage_path = stage_path
      @networks = networks
      @wpa_country = wpa_country
    end

    def run
      read_json_input
      read_template
      save_conf
    end

    def read_json_input
      json_file = @stage_path.to_s + 'files/wpa_supplicant.json'
      if File.file?(json_file)
        File.open(json_file, 'r+') do |f|
          data = JSON.parse(f.read)
          @networks = data['Networks'].map {|rd| WifiNetwork.new(rd['ssid'], rd['wpsk'])}
        end
      end
    end

    def read_template
      File.open(@stage_path.to_s + 'files/wpa_supplicant.conf.erb', 'r+') do |f|
        @template = f.read
      end
    end

    def render
      ERB.new(@template).result(binding)
    end

    def save_conf
      File.open(@stage_path.to_s + 'files/wpa_supplicant.conf', 'w+') do |f|
        f.write(render)
      end
    end

  end
end

