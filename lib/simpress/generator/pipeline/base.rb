# frozen_string_literal: true

require "simpress/config"
require "simpress/errors"
require "simpress/json"
require "simpress/paginator"
require "simpress/path"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Pipeline
      class Base
        class << self
          def generate(...)
            case Simpress::Config.instance.mode
            when "html"
              generate_html(...)
            when "json"
              generate_json(...)
            else
              raise Simpress::Errors::UnknownModeError, "Unknown mode: #{Simpress::Config.instance.mode.inspect}"
            end
          end

          # simplecov:disable
          def generate_html(...)
            raise NotImplementedError
          end

          def generate_json(...)
            raise NotImplementedError
          end
          # simplecov:enable

          def each_page(posts, prefix = nil)
            raise Simpress::Errors::BlockRequiredError, "Simpress::Generator::Pipeline::BaseRenderer.each_page requires a block" unless block_given?

            per_page  = Simpress::Config.instance.paginate || 10
            page_size = (posts.size / per_page.to_f).ceil
            posts.each_slice(per_page).with_index(1) do |slice_posts, page|
              paginator = Simpress::Paginator.new(page: page, maxpage: page_size, prefix: prefix)
              yield slice_posts, paginator
            end

            page_size
          end

          def path(dest)
            Simpress::Path.wrap(dest)
          end

          def write_html(dest, template:, **context, &)
            content = Simpress::Theme.render(template, **context)
            write(dest, content, "html", &)
          end

          def write_json(dest, data, **, &)
            content = Simpress::JSON.dump(data, **)
            write(dest, content, "json", &)
          end

          def write(dest, data, ext, &)
            file_path = path(dest).with_ext(ext).build
            Simpress::Writer.write(file_path, data, &)
          end
        end
      end
    end
  end
end
