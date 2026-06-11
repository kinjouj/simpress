# frozen_string_literal: true

require "simpress/config"
require "simpress/writer"

class SimpressCLI < Thor
  desc "scss", "Compile SCSS"
  def scss
    css = Sass.compile("scss/style.scss", quiet_deps: true, silence_deprecations: ["if-function"], load_paths: ["node_modules"])
    Simpress::Writer.write("css/style.css", css.css)
  rescue Sass::CompileError => e
    raise e.full_message, cause: nil
  end
end
