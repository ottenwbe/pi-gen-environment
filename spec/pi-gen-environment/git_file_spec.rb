require 'pi-gen-environment/git_file'
require 'fileutils'
require 'pathname'

RSpec.describe Git do

  let(:git_path) {'../pi-gen-test'}
  let(:default_git) {'https://github.com/ottenwbe/pi-gen-environment.git'}

  it 'allows to create and remove a "gitpath" file' do
    git_file = Git.new(git_path, default_git)
    git_file.run do
      expect(Pathname.new("#{git_path}")).to be_directory
    end
  end

end