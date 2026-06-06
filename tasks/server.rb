# tasks/server.rb
# frozen_string_literal: true

class SimpressCLI < Thor
  desc "server", "Build and start server on public/"
  def server
    build
    exec "ruby -run -e httpd #{OUTPUT_DIR} -p 4000"
  end
end
