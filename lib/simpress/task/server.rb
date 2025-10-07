# frozen_string_literal: true

module Simpress
  class Task
    class Server < Rake::TaskLib
      def initialize
        super
        define_server_task
        define_preview_task
        define_watch_task
      end

      private

      def define_server_task
        desc "server"
        task :server do
          server
        end
      end

      def define_preview_task
        desc "preview"
        task :preview do
          pid = nil

          loop do
            if pid.nil?
              pid = fork { Rake::Task["build"].execute }
            else
              server
            end
          end
        end
      end

      def define_watch_task
        desc "watch"
        task :watch do
          pid = nil

          loop do
            if pid.nil?
              pid = fork { sh "guard --no-interactions --no-bundler-warning", verbose: false }
            else
              server
            end
          end
        end
      end

      def server
        httpd_pid = Process.spawn("ruby -run -e httpd #{Simpress::Config.instance.output_dir} -p 4000")
        trap("INT") do
          Process.kill(9, httpd_pid) rescue Errno::ESRCH # rubocop:disable Style/RescueModifier
          exit 0
        end

        Process.wait(httpd_pid)
      end
    end
  end
end
