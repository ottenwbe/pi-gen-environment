require 'fileutils'
require 'logger'



class Workspace

  @@logger = Logger.new(STDERR)
  @workspace_directory = '../pi-gen'
  @git_path = 'https://github.com/ottenwbe/pi-gen.git'

  def initialize(workspace_dir = @workspace_directory, git_path = @git_path)
    @@logger.info 'Creating workspace'
    @workspace_directory = workspace_dir.to_s unless workspace_dir.nil? or workspace_dir == ''
    @git_path = git_path.to_s unless git_path.nil? or git_path == ''
  end

  def run
    get_or_refresh
    yield
    clean_up
  end

  def get_or_refresh
    system 'git pull %s -r' % @workspace_directory if File.directory?(@workspace_directory)
    system "git clone #{@git_path} #{@workspace_directory}" unless File.directory?(@workspace_directory)
  end

  def clean_up
    FileUtils.rm_rf @workspace_directory
  end

end
