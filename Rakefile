# frozen_string_literal: true

$LOAD_PATH.unshift "./lib"

require "bundler/setup"
Bundler.require

require "rake/clean"
require "rspec/core/rake_task"
require "simpress"
require "simpress/task"
Simpress::Task.register_tasks
RSpec::Core::RakeTask.new("spec")
CLEAN.include("public/*")

desc "build_html"
task :build_html do
  output_dir = Simpress::Config.instance.output_dir
  files = cd(output_dir, verbose: false) { Dir["**/*.html"] }
  SitemapGenerator::Sitemap.default_host = Simpress::Config.instance.host
  SitemapGenerator::Sitemap.sitemaps_path = "./"
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::FileAdapter.new
  SitemapGenerator::Sitemap.create(compress: false) do
    files.sort.find_all {|s| !s.match(/^archive|category/) }.each do |file|
      add file, changefreq: "always", priority: "1.0", lastmod: File.mtime("#{output_dir}/#{file}")
    end
  end
end

desc "build_json"
task :build_json do
  sh "npm run build", verbose: false
end

desc "github deploy"
task :github_deploy do
  cd(Simpress::Config.instance.output_dir, verbose: false) do
    sh "git add -A", verbose: false
    sh "git commit -m \"Site updated at #{Time.now.utc}\"", verbose: false
    sh "git push origin master", verbose: false
  end
end
