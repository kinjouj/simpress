# frozen_string_literal: true

$LOAD_PATH.unshift "./lib"

require "bundler/setup"
Bundler.require

require "benchmark"
require "rake/clean"
require "simpress"
require "simpress/sitemap"

OUTPUT_DIR = Simpress::Config.output_dir
CLEAN.include("#{OUTPUT_DIR}/*")

desc "build"
task build: :clean do
  result = Benchmark.realtime do
    cp_r("static/.", OUTPUT_DIR, preserve: true, verbose: false)
    Simpress::Logger.debug("MODE: #{Simpress::Config.instance.mode}")
    GC.disable
    Simpress.build { Rake::Task["build_#{Simpress::Config.instance.mode}"].invoke }
    GC.enable
  end

  Simpress::Logger.debug("build time: #{result}")
end

desc "build_html"
task build_html: :build_scss do
  files = cd(OUTPUT_DIR, verbose: false) do
    FileList["**/*.html"].exclude(/^(archives|page)/, /index\.html$/).map {|f| [f, File.mtime(f)] }.sort_by(&:last)
  end

  Simpress::Sitemap.build(Simpress::Config.instance.host) do
    files.each {|file, mtime| url(file: file, lastmod: mtime.iso8601) }
  end
end

task :build_scss do
  scss = Sass.compile("scss/style.scss", quiet_deps: true, silence_deprecations: ["if-function"], load_paths: ["node_modules"])
  Simpress::Writer.write("css/style.css", scss.css)
rescue Sass::CompileError => e
  raise e.full_message, cause: nil
end

desc "build_json"
task :build_json do
  # sh "npm run build", verbose: false
end

desc "github deploy"
task :github_deploy do
  cd(OUTPUT_DIR, verbose: false) do
    sh "git add -A", verbose: false
    sh "git commit -m \"Site updated at #{Time.now.utc}\"", verbose: false
    sh "git push origin master", verbose: false
  end
end

desc "server"
task server: :build do
  exec "ruby -run -e httpd #{OUTPUT_DIR} -p 4000"
end
