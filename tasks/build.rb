# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"
require "simpress/sitemap"
require "simpress/writer"

class SimpressCLI < Thor
  OUTPUT_DIR = Simpress::Config.output_dir
  PLUGIN_DIR = Simpress::Config.plugin_dir

  desc "build", "Build the site"
  def build
    invoke :clean
    result = Benchmark.realtime do
      copy_static
      Simpress::Logger.debug("MODE: #{Simpress::Config.instance.mode}")
      GC.disable
      build_plugin_scss
      Simpress.build { send(:"build_#{Simpress::Config.instance.mode}") }
    end

    Simpress::Logger.debug("build time: #{result}")
  ensure
    GC.enable
  end

  private

  def copy_static
    plugin_dirs = Simpress::Config.instance.plugins.map {|name| "#{PLUGIN_DIR}/#{name}/static" }
    ["static", *plugin_dirs].each {|dir| FileUtils.cp_r("#{dir}/.", OUTPUT_DIR, preserve: true, verbose: false) if Dir.exist?(dir) }
  end

  def build_html
    build_scss
    build_sitemap
  end

  def build_plugin_scss
    lines = Simpress::Config.instance.plugins.flat_map do |name|
      Dir.glob("#{PLUGIN_DIR}/#{name}/scss/_*.scss").map {|file| %(@forward "../#{File.dirname(file)}/#{File.basename(file, '.scss').delete_prefix('_')}";) }
    end

    File.write("scss/_plugins.scss", lines.map {|line| "#{line}\n" }.join)
  end

  def build_scss
    css = Sass.compile("scss/style.scss", quiet_deps: true, silence_deprecations: ["if-function"], load_paths: ["node_modules"])
    Simpress::Writer.write("css/style.css", css.css)
  rescue Sass::CompileError => e
    raise e.full_message, cause: nil
  end

  def build_sitemap
    files = Dir.chdir(OUTPUT_DIR) do
      files = Dir.glob("**/*.html")
      files.reject! {|f| f == "index.html" || f.start_with?("archives/") }
      files.map! {|f| [f, File.mtime(f)] }
      files.sort_by(&:last)
    end

    Simpress::Sitemap.build(Simpress::Config.instance.host) do
      files.each {|file, mtime| url(file: file, lastmod: mtime.iso8601) }
    end
  end

  def build_json
    # sh "npm run build"
  end
end
