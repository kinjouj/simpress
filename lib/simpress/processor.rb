# frozen_string_literal: true

module Simpress
  module Processor
    SOURCE_DIR = Simpress::Config.instance.source_dir || "source"

    def self.generate
      posts      = []
      categories = {}
      Dir["#{SOURCE_DIR}/**/*.{md,markdown}"].each do |file|
        data = Simpress::Parser.parse(file)
        next if data.nil? || !data.published

        data.categories.each do |category|
          key = category.to_url

          if categories[key].nil?
            categories[key] = category
          else
            categories[key].increment
          end

          # categories[key].last_update = data.date
        end

        Simpress::Logger.info("PARSE COMPLETE: #{file}")
        posts << data
      end

      posts, pages = posts.partition {|post| post.layout == :post }
      posts.sort_by! {|post| -post.date.to_time.to_i }
      Simpress::Plugin::Preprocessor.process(posts, pages, categories)
      Simpress::Renderer.generate(posts, pages, categories)
      Simpress::Context.clear
      Simpress::Theme.clear
    end
  end
end
