# frozen_string_literal: true

$LOAD_PATH.unshift "./lib"

require "bundler/setup"
Bundler.require

require "rake/clean"
require "rspec/core/rake_task"
require "simpress"
require "simpress/sitemap"
require "simpress/task"

Simpress::Task.register_tasks
RSpec::Core::RakeTask.new("spec")
CLEAN.include("public/*")

desc "build_html"
task :build_html do
  output_dir = Simpress::Config.instance.output_dir
  files = cd(output_dir, verbose: false) do
    Dir["**/*.html"].select {|file| !file.start_with?("archives") && !file.end_with?("index.html") }
  end

  Simpress::Sitemap.build(Simpress::Config.instance.host) do
    files.sort!
    files.each do |file|
      url(file: file, lastmod: File.stat(File.join(output_dir, file)).mtime.iso8601)
    end
  end
end

desc "build_json"
task :build_json do
  # sh "npm run build", verbose: false
end

desc "github deploy"
task :github_deploy do
  cd(Simpress::Config.instance.output_dir, verbose: false) do
    sh "git add -A", verbose: false
    sh "git commit -m \"Site updated at #{Time.now.utc}\"", verbose: false
    sh "git push origin master", verbose: false
  end
end
