# frozen_string_literal: true

require "simpress/config"

class SimpressCLI < Thor
  desc "server", "Build and start server on public/"
  def server
    invoke :build
    exec "ruby -run -e httpd #{Simpress::Config.output_dir} -b 127.0.0.1 -p 4000"
  end
end
