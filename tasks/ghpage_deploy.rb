# frozen_string_literal: true

class SimpressCLI < Thor
  desc "ghpage_deploy", "Deploy to GitHub Pages"
  def ghpage_deploy
    Dir.chdir(OUTPUT_DIR) do
      system "git add -A"
      system "git commit -m \"Site updated at #{Time.now.utc}\""
      system "git push origin master"
    end
  end
end
