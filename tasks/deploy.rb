# frozen_string_literal: true

require "simpress/config"

class SimpressCLI < Thor
  class Github
    def self.deploy
      Dir.chdir(Simpress::Config.output_dir) do
        system("git add -A") || exit(1)
        system("git commit -m \"Site updated at #{Time.now.utc}\"") || exit(1)
        system("git push origin master") || exit(1)
      end
    end
  end

  desc "deploy [DEPLOYER]", "Deploy the site"
  def deploy(deployer = "github")
    klass = deployer.split("_").map(&:capitalize).join
    self.class.const_get(klass).deploy
  end
end
