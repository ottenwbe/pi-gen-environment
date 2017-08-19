require 'fileutils'
require_relative 'logex'

class Workspace

  DEFAULT_WORKSPACE_DIRECTORY = '../pi-gen'
  DEFAULT_GIT_PATH = 'https://github.com/ottenwbe/pi-gen.git'

  def initialize(workspace_dir = DEFAULT_WORKSPACE_DIRECTORY, git_path = DEFAULT_GIT_PATH)
    @workspace_directory = if workspace_dir.nil? or workspace_dir == ''
                             workspace_dir.to_s
                           else
                             DEFAULT_WORKSPACE_DIRECTORY
                           end
    @git_path = if git_path.nil? or git_path == ''
                  git_path.to_s
                else
                  DEFAULT_GIT_PATH
                end
    $logger.info "Creating workspace at '#{@git_path}'"
  end

  def do_work
    get_or_refresh
    yield
    clean_up
  end

  def get_or_refresh
    if File.directory?(@workspace_directory)
      system "git pull #{@workspace_directory} -r"
    else
      system "git clone #{@git_path} #{@workspace_directory}"
    end
  end

  def clean_up
    FileUtils.rm_rf @workspace_directory
  end

end
