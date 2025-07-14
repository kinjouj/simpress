# frozen_string_literal: true

module Simpress
  module Plugin
    module Preprocessor
      class Hostname
        extend Simpress::Plugin::Preprocessor

        def self.run(*_args)
          return unless config.mode.to_s == "html"

          register_context(hostname: config.host)
        end
      end
    end
  end
end
