# frozen_string_literal: true

require "simpress/config"
require "simpress/json"
require "simpress/paginator"
require "simpress/theme"
require "simpress/uri"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class BaseRenderer
        class << self
          def generate(...)
            case Simpress::Config.instance.mode
            when "html"
              generate_html(...)
            when "json"
              generate_json(...)
            else
              raise "ERROR: Unknown mode"
            end
          end

          # :nocov:
          def generate_html(...)
            raise NotImplementedError
          end

          def generate_json(...)
            raise NotImplementedError
          end
          # :nocov:

          def each_page(posts, prefix = nil)
            raise "ERROR" unless block_given?

            per_page  = Simpress::Config.instance.paginate || 10
            page_size = (posts.size / per_page.to_f).ceil
            posts.each_slice(per_page).with_index(1) do |slice_posts, page|
              paginator = Simpress::Paginator.new(page: page, maxpage: page_size, prefix: prefix)
              yield slice_posts, paginator
            end

            page_size
          end

          def uri(path)
            Simpress::Uri.wrap(path)
          end

          def write_html(path, template:, **context, &)
            content = Simpress::Theme.render(template, **context)
            write(path, content, "html", &)
          end

          def write_json(path, data, **, &)
            content = Simpress::JSON.dump(data, **)
            write(path, content, "json", &)
          end

          def write(path, data, ext, &)
            file_path = uri(path).with_ext(ext).build
            Simpress::Writer.write(file_path, data, &)
          end
        end
      end
    end
  end
end
