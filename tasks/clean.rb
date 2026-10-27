# frozen_string_literal: true

require "simpress/config"

class SimpressCLI < Thor
  desc "clean", "Clean output directory"
  def clean
    Dir.glob("#{Simpress::Config.output_dir}/*").each {|f| FileUtils.rm_rf(f) }
  end
end
