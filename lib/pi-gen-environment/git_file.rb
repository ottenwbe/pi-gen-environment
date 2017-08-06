require 'fileutils'

class Git

  @git_download_directory = '../pi-gen'
  @git_path = 'https://github.com/ottenwbe/pi-gen.git'

  def initialize(git_download_directory = @git_download_directory, git_path = @git_path)
    @git_download_directory = git_download_directory
    @git_path = git_path
  end

  def run
    get_or_refresh
    yield
    clean_up
  end

  def get_or_refresh
    system 'git pull %s -r' % @git_download_directory if File.directory?(@git_download_directory)
    system "git clone #{@git_path} #{@git_download_directory}" unless File.directory?(@git_download_directory)
  end

  def clean_up
    FileUtils.rm_rf @git_download_directory
  end

end
