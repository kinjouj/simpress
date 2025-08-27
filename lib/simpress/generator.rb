# frozen_string_literal: true

module Simpress
  module Generator
    SOURCE_DIR = Simpress::Config.instance.source_dir || "source"

    def self.generate
      posts      = []
      categories = {}
      Dir["#{SOURCE_DIR}/**/*.{md,markdown}"].each do |file|
        data = Simpress::Parser.parse(file)
        next unless data.published

        data.categories.each do |category|
          key = category.key

          if categories[key].nil?
            categories[key] = category
          else
            categories[key].count += 1
          end

          categories[key].last_update = data.date
        end

        Simpress::Logger.info("PARSE COMPLETE: #{file}")
        posts << data
      end

      posts, pages = posts.partition {|post| post.layout == :post }
      posts.sort_by! {|post| -post.date.to_time.to_i }
      Simpress::Plugin.process(posts, pages, categories)
      Simpress::Renderer.generate(posts, pages, categories)
      Simpress::Context.clear
      Simpress::Theme.clear
    end
  end
end
