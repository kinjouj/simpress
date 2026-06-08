# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"
require "simpress/sitemap"
require "simpress/writer"

class SimpressCLI < Thor
  desc "build", "Build the site"
  def build
    invoke :clean
    result = Benchmark.realtime do
      FileUtils.cp_r("static/.", Simpress::Config.output_dir, preserve: true, verbose: false)
      Simpress::Logger.debug("MODE: #{Simpress::Config.instance.mode}")
      Simpress.build { send(:"build_#{Simpress::Config.instance.mode}") }
    end

    Simpress::Logger.debug("build time: #{result}")
  end

  private

  def build_html
    build_scss
    files = Dir.chdir(Simpress::Config.output_dir) do
      files = Dir.glob("**/*.html")
      files.reject! {|f| f.match?(/^(archives|page)/) || f.match?(/index\.html$/) }
      files.map! {|f| [f, File.mtime(f)] }
      files.sort_by(&:last)
    end

    Simpress::Sitemap.build(Simpress::Config.instance.host) do
      files.each {|file, mtime| url(file: file, lastmod: mtime.iso8601) }
    end
  end

  def build_scss
    scss = Sass.compile("scss/style.scss", quiet_deps: true, silence_deprecations: ["if-function"], load_paths: ["node_modules"])
    Simpress::Writer.write("css/style.css", scss.css)
  rescue Sass::CompileError => e
    raise e.full_message, cause: nil
  end

  def build_json
    # sh "npm run build"
  end
end
