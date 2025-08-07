# frozen_string_literal: true

$LOAD_PATH.unshift "./lib"

require "bundler/setup"
Bundler.require

require "rake/clean"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new("spec")
CLEAN.include("public/*")

require "simpress"
OUTPUT_DIR = Simpress::Config.instance.output_dir

desc "build"
task :build do
  Rake::Task["clean"].execute
  result = Benchmark.realtime do
    GC.disable
    cp_r("static/.", OUTPUT_DIR, preserve: true, verbose: false)
    Simpress.build do
      Rake::Task["build_scss"].execute
      Rake::Task["build_#{Simpress::Config.instance.mode}"].execute
    end
    GC.enable
  end

  puts "build time: #{result}"
end

task :build_html do
  Rake::Task["build_sitemap"].execute
end

desc "build_json"
task :build_json do
  # sh "npm run build"
end

desc "build_scss"
task :build_scss do
  cd("scss", verbose: false) { Dir["**/*.scss"] }.each do |file|
    outfile = File.join("css", File.dirname(file), "#{File.basename(file, '.scss')}.css")
    scss    = Sass.compile("scss/#{file}", style: :compressed, verbose: true)
    Simpress::Writer.write(outfile, scss.css) {|filepath| Simpress::Logger.info("scss -> css: #{filepath}") }
  end
end

desc "build_sitemap"
task :build_sitemap do
  files = cd(OUTPUT_DIR, verbose: false) { Dir["**/*.html"] }
  SitemapGenerator::Sitemap.default_host = Simpress::Config.instance.host
  SitemapGenerator::Sitemap.sitemaps_path = "./"
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::FileAdapter.new
  SitemapGenerator::Sitemap.create(compress: false) do
    files.sort.find_all {|s| !s.match(/^archive|category/) }.each do |file|
      add file, changefreq: "always", priority: "1.0", lastmod: File.mtime("#{OUTPUT_DIR}/#{file}")
    end
  end
end

desc "server"
task :server do
  httpd_pid = Process.spawn("ruby -run -e httpd #{OUTPUT_DIR} -p 4000")
  trap("INT") do
    Process.kill(9, httpd_pid) rescue Errno::ESRCH
    exit 0
  end

  Process.wait(httpd_pid)
end

desc "watch"
task :watch do
  pid = nil

  loop do
    if pid.nil?
      pid = fork { sh "guard --no-interactions --no-bundler-warning", verbose: false }
    else
      Rake::Task["server"].execute
    end
  end
end

desc "preview"
task :preview do
  pid = nil

  loop do
    if pid.nil?
      pid = fork { Rake::Task["build"].execute }
    else
      Rake::Task["server"].execute
    end
  end
end

desc "github deploy"
task :github_deploy do
  cd(OUTPUT_DIR, verbose: false) do
    sh "git add -A", verbose: false
    sh "git commit -m \"Site updated at #{Time.now.utc}\"", verbose: false
    sh "git push origin master", verbose: false
  end
end
