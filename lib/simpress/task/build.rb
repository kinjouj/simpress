# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"
require "simpress/writer"

module Simpress
  class Task
    class Build < Rake::TaskLib
      def initialize
        super
        define_build_task
      end

      private

      def define_build_task
        desc "build"
        task :build do
          build
        end
      end

      def build
        Rake::Task["clean"].execute
        cp_r("static/.", Simpress::Config.instance.output_dir, preserve: true, verbose: false)
        result = Benchmark.realtime do
          GC.disable
          Simpress.build do
            # build_scss
            Rake::Task["build_#{Simpress::Config.instance.mode}"].execute
          end
          GC.enable
        end

        puts "build time: #{result}"
      end

      def build_scss
        cd("scss", verbose: false) { Dir["**/*.scss"] }.each do |file|
          basename = File.basename(file, ".scss")
          outfile  = File.join("css", File.dirname(file), "#{basename}.css")
          scss     = Sass.compile("scss/#{file}", style: :compressed, verbose: true)
          Simpress::Writer.write(outfile, scss.css) {|filepath| Simpress::Logger.info("scss -> css: #{filepath}") }
        end
      end
    end
  end
end
