# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/logger"

module Simpress
  module Generator
    module Renderer
      module Archive
        class TaxonomyRenderer < BaseRenderer
          DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :cover, :description].freeze

          def self.generate_html(taxonomies)
            taxonomies.each do |taxonomy|
              taxonomy.terms.each_value do |term|
                prefix = "/archives/#{taxonomy.name}/#{term.key}"
                term.posts.sort_by! {|a| -a.timestamp }
                each_page(term.posts, prefix) do |posts, paginator|
                  path = paginator.current_page
                  write_html(path, template: "index", key: term.name, posts: posts, paginator: paginator) do |file_path|
                    Simpress::Logger.info("[BUILD CATEGORY]: #{file_path}")
                  end
                end
              end
            end
          end

          def self.generate_json(taxonomies)
            taxonomies.each do |taxonomy|
              base_path = uri("/archives/#{taxonomy.name}")
              taxonomy.terms.each_value do |term|
                term.posts.sort_by! {|a| -a.timestamp }
                page_size = each_page(term.posts) do |posts, paginator|
                  path = base_path.path(term.key, paginator.page)
                  write_json(path, posts, keys: DATA_JSON_KEYS) do |file_path|
                    Simpress::Logger.info("[BUILD CATEGORY]: #{file_path}")
                  end
                end

                write_json(base_path.path(term.key, "meta.json"), { total_pages: page_size }) do |file_path|
                  Simpress::Logger.info("[BUILD CATEGORY]: #{file_path}")
                end
              end
            end
          end
        end
      end
    end
  end
end
