# frozen_string_literal: true

$LOAD_PATH.unshift "./lib"

require "bundler/setup"
Bundler.require

require "benchmark"
require "rake/clean"
require "simpress"
require "simpress/config"
require "simpress/logger"
require "simpress/sitemap"

OUTPUT_DIR = Simpress::Config.output_dir
CLEAN.include("#{OUTPUT_DIR}/*")

desc "build"
task build: :clean do
  cp_r("static/.", OUTPUT_DIR, preserve: true, verbose: false)
  GC.disable
  result = Benchmark.realtime { Simpress.build { Rake::Task["build_#{Simpress::Config.instance.mode}"].execute } }
  GC.enable
  Simpress::Logger.debug("build time: #{result}")
end

desc "build_html"
task :build_html do
  files = cd(OUTPUT_DIR, verbose: false) do
    Dir["**/*.html"].select {|file| !file.start_with?("archives", "page") && !file.end_with?("index.html") }
  end

  Simpress::Sitemap.build(Simpress::Config.instance.host) do
    files.sort!
    files.each {|file| url(file: file, lastmod: File.stat(File.join(OUTPUT_DIR, file)).mtime.iso8601) }
  end
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
  httpd_pid = Process.spawn("ruby -run -e httpd #{OUTPUT_DIR} -p 4000")
  trap("INT") do
    Process.kill(9, httpd_pid) rescue Errno::ESRCH # rubocop:disable Style/RescueModifier
    exit 0
  end

  Process.wait(httpd_pid)
end

task :guard do
  sh "guard --no-interactions --no-bundler-warning"
end

desc "watch"
multitask watch: [:server, :guard]
