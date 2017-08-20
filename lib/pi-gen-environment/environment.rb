require_relative 'logex'

class Environment
  def build
    $logger.warn 'Missing start command'
  end

  def destroy
    $logger.warn 'Missing stop command'
  end

  def copy_file (filename)
    $logger.warn "Missing copy_file: file '#{filename}' cannot be copied"
  end

  def run_command (command)
    $logger.warn "Missing run_command: command '#{command}' cannot be executed"
  end

end