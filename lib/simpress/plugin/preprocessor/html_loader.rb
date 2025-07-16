# frozen_string_literal: true

module Simpress
  module Plugin
    module Preprocessor
      class HtmlLoader
        extend Simpress::Plugin::Preprocessor

        def self.run(*_args)
          return unless config.mode.to_s == "html"

          Dir["#{Simpress::Theme::THEME_DIR}/html/**/*.html"].each do |file|
            basename = File.basename(file, ".html")
            register_context("html_#{basename.tr('.', '')}": File.read(file))
          end
        end
      end
    end
  end
end
