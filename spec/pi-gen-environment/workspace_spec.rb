require 'pi-gen-environment/workspace'
  require 'fileutils'
  require 'pathname'

  RSpec.describe Workspace do

    let(:git_path) {'../pi-gen-test'}
    let(:default_git) {'https://github.com/ottenwbe/pi-gen-environment.git'}

    it 'allows to create and remove a workspace and destroys it afterwards' do
      git_file = Workspace.new(git_path, default_git)
      git_file.do_work do
        expect(Pathname.new("#{git_path}")).to be_directory
      end
    end

  end