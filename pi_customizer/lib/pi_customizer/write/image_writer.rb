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

require 'pi_customizer/utils/logex'

module PiCustomizer

  ##
  # ImageWriter writes raspberry pi images to devices (e.g., SD cards)

  class ImageWriter

    def initialize(as_root)
      @zip_formats = ['.zip']
      @img_formats = ['.img']
      @as_root = as_root
    end

    def write(image, device)
      dispatch_write(image, device)
    end

    private def dispatch_write(image, device)
      extension = File.extname(image)
      if @zip_formats.include? extension
        write_zip(image, device)
      elsif @img_formats.include? extension
        write_img(image, device)
      else
        raise 'No valid image format'
      end
    end

    private def write_zip(image, device)
      run("unzip -p #{image} | dd of=#{device} bs=4M conv=fsync", @as_root)
    end

    private def write_img(image, device)
      run("dd if=#{image} of=#{device} bs=4M conv=fsync", @as_root)
    end

    private def run(command, as_root)
      $logger.info 'Executing run as_root=' + as_root.to_s
      if as_root
        system 'sudo ' + command
      else
        system command
      end
    end

  end
end

