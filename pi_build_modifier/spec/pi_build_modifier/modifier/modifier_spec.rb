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

require_relative '../../spec_helper'
require 'rspec'
require 'fileutils'
require 'pi_build_modifier/modifier/pi_modifier'
require 'pi_build_modifier/modifier/mapper'


module PiBuildModifier
  RSpec.describe PiModifier do

    let(:tmp_json_config) {'tmp_config.json'}

    before do
      File.open(tmp_json_config, 'w') {|file| file.write('{"a":1,"b":2}')}
    end

    after do
      FileUtils.rm(tmp_json_config)
    end

    it 'only accepts mappers that are a class Mapper' do
      #Given
      pi_modifier = PiModifier.new

      #When #Then
      expect{ pi_modifier.with_mapper(nil) }.to raise_error

    end

    it 'performs a modification task on a mapper object with the specification given in a json configuration' do

      #Given
      pi_modifier = PiModifier.new
      test_sum_component = TestSumComponent.new(nil)

      #When
      pi_modifier.with_json_configuration(tmp_json_config)
      pi_modifier.with_mapper(test_sum_component)
      pi_modifier.modify

      #Then
      expect(test_sum_component.a).to equal 1
      expect(test_sum_component.b).to equal 2
      expect(test_sum_component.sum).to equal 3

    end
  end

  class TestSumComponent < Mapper
    attr_accessor :a, :b, :sum

    def map(json_data)
      @a = json_data['a']
      @b = json_data['b']
    end

    def modify
      @sum =  @a + @b
    end

  end

end
