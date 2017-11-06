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

require_relative 'spec_helper'
require 'pi_customizer'
require 'fileutils'
require 'pi_customizer/utils/logex'
require 'pi_customizer/version'
require 'rspec'

module PiCustomizer
  describe PiCustomizer do

    context 'ECHO' do
      it 'starts a build when the command line parameter \'build\' is passed' do
        expect(STDOUT).to receive(:puts).with('Echo: - Git Path: , Workspace Path: , Config Path: ')
        PiCustomizer.start(%w(build ECHO))
      end
      it 'reads the git_path variable' do
        expect(STDOUT).to receive(:puts).with('Echo: - Git Path: git, Workspace Path: , Config Path: ')
        PiCustomizer.start(%w(build ECHO --git_path=git))
      end
      it 'reads the config_path variable' do
        expect(STDOUT).to receive(:puts).with('Echo: - Git Path: , Workspace Path: , Config Path: cfg')
        PiCustomizer.start(%w(build ECHO --config_file=cfg))
      end
    end

    context 'version' do
      it 'returns the app\'s version' do
        expect(STDOUT).to receive(:puts).with(VERSION)
        PiCustomizer.start(%w(version))
      end

    end

  end
end