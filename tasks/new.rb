# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"

class SimpressCLI < Thor
  desc "new FILENAME", "Create a new post"
  def new(filename)
    date = Date.today
    dir  = "#{Simpress::Config.source_dir}/#{date.strftime('%Y/%m')}"
    path = "#{dir}/#{date.strftime('%Y-%m-%d')}-#{filename}.markdown"
    FileUtils.mkdir_p(dir)
    FileUtils.touch(path)
    Simpress::Logger.debug("Created: #{path}")
  end
end
