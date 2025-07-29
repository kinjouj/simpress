# frozen_string_literal: true

$LOAD_PATH.unshift "./lib"

require "bundler/setup"
Bundler.require(:default, :test)

require "rake/clean"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new("spec")
CLEAN.include("public/*")
CLEAN.include("logs/build.log")

require "simpress"
OUTPUT_DIR = Simpress::Config.instance.output_dir

desc "build"
task :build do
  Rake::Task["clean"].invoke
  result = Benchmark.realtime do
    GC.disable
    cp_r "static/.", OUTPUT_DIR
    Rake::Task["build_scss"].invoke
    Simpress.build
    GC.enable
    Rake::Task["build_#{Simpress::Config.instance.mode}"].invoke
  end

  puts "build time: #{result}"
end

task :build_html do
  Rake::Task["build_sitemap"].invoke
end

desc "build_json"
task :build_json do
  # sh "npm run build"
end

desc "build_scss"
task :build_scss do
  FileUtils.mkdir_p("#{OUTPUT_DIR}/css")
  Dir["scss/*.scss"].each do |file|
    basename = File.basename(file, ".scss")
    outfile  = "#{OUTPUT_DIR}/css/#{basename}.css"
    scss = Sass.compile(file, verbose: true)
    File.write(outfile, scss.css)
  end
end

desc "build_sitemap"
task :build_sitemap do
  files = cd(OUTPUT_DIR) { Dir["**/*.html"] }
  SitemapGenerator::Sitemap.default_host = Simpress::Config.instance.host
  SitemapGenerator::Sitemap.sitemaps_path = "./"
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::FileAdapter.new
  SitemapGenerator::Sitemap.create(compress: false) do
    files.sort.each do |file|
      next if file.match(/^archive|category/)

      add file, changefreq: "always", priority: "1.0", lastmod: File.mtime("#{OUTPUT_DIR}/#{file}")
    end
  end
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

desc "server"
task :server do
  httpd_pid = Process.spawn("ruby -run -e httpd #{OUTPUT_DIR} -p 4000")
  trap("INT") do
    Process.kill(9, httpd_pid) rescue Errno::ESRCH
    exit 0
  end
  Process.wait(httpd_pid)
end

desc "github deploy"
task :github_deploy do
  cd OUTPUT_DIR do
    sh "git add -A", verbose: false
    sh "git commit -m \"Site updated at #{Time.now.utc}\"", verbose: false
    sh "git push origin master", verbose: false
  end
end
