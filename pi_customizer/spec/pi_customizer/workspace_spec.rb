require 'pi_customizer/workspace/workspace'
require 'fileutils'
require 'pathname'

module PiCustomizer
  module Workspace
    RSpec.describe Workspace do

      let(:git_path) {'../pi-gen-test'}
      let(:default_git) {'https://github.com/ottenwbe/pi_customizer.git'}

      #it 'allows to create and remove a workspace and destroys it afterwards' do
      #  git_file = Workspace.new(git_path, default_git)
      #  git_file.do_work do
      #    expect(Pathname.new("#{git_path}")).to be_directory
      #  end
      #end
    end
  end
end