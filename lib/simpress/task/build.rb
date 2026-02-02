# frozen_string_literal: true

require "benchmark"
require "pathname"
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
        build_scss
        GC.disable
        result = Benchmark.realtime do
          Simpress.build do
            Rake::Task["build_#{Simpress::Config.instance.mode}"].execute
          end
        end

        GC.enable
        GC.start
        Simpress::Logger.debug("build time: #{result}")
      end

      def build_scss
        return unless File.exist?("scss/style.scss")

        begin
          scss = Sass.compile("scss/style.scss", style: :compressed, verbose: true)
          Simpress::Writer.write("css/style.css", scss.css) do |filepath|
            Simpress::Logger.debug("scss -> css: #{filepath}")
          end
        rescue => e
          raise e.full_message
        end
      end
    end
  end
end
