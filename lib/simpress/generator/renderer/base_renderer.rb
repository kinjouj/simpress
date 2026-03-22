# frozen_string_literal: true

require "simpress/json"
require "simpress/logger"
require "simpress/theme"
require "simpress/uri"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class BaseRenderer
        def self.generate(...)
          case Simpress::Config.instance.mode
          when "html"
            generate_html(...)
          when "json"
            generate_json(...)
          else
            raise "ERROR: Unknown mode"
          end
        end

        def self.uri(path)
          Simpress::Uri.wrap(path)
        end

        def self.build_context(**kwargs)
          kwargs
        end

        def self.write_html(path, template:, context:, &)
          content = Simpress::Theme.render(template, **context)
          write(path, content, "html", &)
        end

        def self.write_json(path, data, **, &)
          content = Simpress::JSON.dump(data, **)
          write(path, content, "json", &)
        end

        def self.write(path, data, ext = nil)
          file_path = ext ? uri(path).with_ext(ext).build : path
          Simpress::Writer.write(file_path, data) {|file_path| yield file_path if block_given? }
        end

        def self.logger_info(msg)
          Simpress::Logger.info(msg)
        end
      end
    end
  end
end
