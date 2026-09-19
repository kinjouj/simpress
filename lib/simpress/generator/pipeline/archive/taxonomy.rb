# frozen_string_literal: true

require "simpress/generator/pipeline/base"
require "simpress/logger"

module Simpress
  module Generator
    module Pipeline
      module Archive
        class Taxonomy < Simpress::Generator::Pipeline::Base
          DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :cover, :description].freeze

          def self.generate_html(taxonomies)
            taxonomies.each do |taxonomy|
              taxonomy.terms.each_value do |term|
                prefix = "/archives/#{taxonomy.name}/#{term.key}"
                term.posts.sort_by! {|a| -a.date.to_i }
                each_page(term.posts, prefix) do |posts, paginator|
                  write_html(paginator.current_page, template: "index", key: term.name, posts: posts, paginator: paginator) do |file|
                    Simpress::Logger.verbose("[BUILD CATEGORY]: #{file}")
                  end
                end
              end
            end
          end

          def self.generate_json(taxonomies)
            taxonomies.each do |taxonomy|
              base_path = path("/archives/#{taxonomy.name}")
              taxonomy.terms.each_value do |term|
                term.posts.sort_by! {|a| -a.date.to_i }
                each_page(term.posts) do |posts, paginator|
                  data = { posts: posts.map {|post| post.to_h(keys: DATA_JSON_KEYS) }, total_pages: paginator.maxpage }
                  write_json(base_path.path(term.key, paginator.page), data) do |file|
                    Simpress::Logger.verbose("[BUILD CATEGORY]: #{file}")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
