# frozen_string_literal: true

require "simpress/config"

class SimpressCLI < Thor
  desc "ghpage_deploy", "Deploy to GitHub Pages"
  def ghpage_deploy
    Dir.chdir(Simpress::Config.output_dir) do
      system "git add -A" || exit(1)
      system "git commit -m \"Site updated at #{Time.now.utc}\"" || exit(1)
      system "git push origin master" || exit(1)
    end
  end
end
