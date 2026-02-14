# frozen_string_literal: true

require "sass-embedded"
require "simpress/logger"
require "simpress/plugin"
require "simpress/writer"

module Simpress
  module Plugin
    class SCSS
      extend Simpress::Plugin

      SCSS_FILE = "scss/style.scss"
      COMPILER_OPTIONS = {
        style: "compressed",
        quiet_deps: true,
        silence_deprecations: ["if-function"],
        load_paths: ["node_modules"],
        verbose: true
      }.freeze

      def self.priority
        100
      end

      def self.run(*_args)
        return unless File.exist?(SCSS_FILE)

        begin
          scss = Sass.compile(SCSS_FILE, **COMPILER_OPTIONS)
          Simpress::Writer.write("css/style.css", scss.css)
        rescue Sass::CompileError => e
          raise e.full_message, cause: nil
        end
      end
    end
  end
end
