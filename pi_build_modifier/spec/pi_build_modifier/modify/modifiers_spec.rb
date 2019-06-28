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
require 'pi_build_modifier/modify/modifiers'


RSpec.describe PiBuildModifier::Modifiers do

  context 'ModifiersBuilder' do

    it 'creates Modifiers' do
      modifier = PiBuildModifier::Modifiers::ModifiersBuilder.build(".", "no.cfg")
      expect(modifier.config_modifiers).not_to be_nil
      expect(modifier.config_modifiers).not_to be_a PiBuildModifier::Modifiers::Modifiers
    end

    it 'creates and adds erb and config file modifiers to the Modifiers' do
      modifier = PiBuildModifier::Modifiers::ModifiersBuilder.build("no.cfg", ".")
      expect(modifier.config_modifiers).to include(be_a PiBuildModifier::Modifiers::ERBConfigModifier)
      expect(modifier.config_modifiers).to include(be_a PiBuildModifier::Modifiers::ConfigFileModifier)
    end

  end
end
