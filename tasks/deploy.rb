# frozen_string_literal: true

require "simpress/config"

class SimpressCLI < Thor
  desc "deploy", "Deploy the site"
  def deploy
    Dir.chdir(Simpress::Config.output_dir) do
      system("git add -A") || exit(1)
      return if system("git diff --cached --quiet")

      system("git commit -m \"Site updated at #{Time.now.utc}\"") || exit(1)
      system("git push origin master") || exit(1)
    end
  end
end
