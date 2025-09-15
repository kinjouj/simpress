# frozen_string_literal: true

module Simpress
  module Generator
    def self.generate
      posts      = []
      categories = {}
      find_sources.each do |file|
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
      const_get(Simpress::Config.instance.mode.to_s.capitalize, false).generate(posts, pages, categories)
      Simpress::Theme.clear
    end

    def self.find_sources
      Dir["#{source_dir}/**/*.{md,markdown}"]
    end

    def self.source_dir
      Simpress::Config.instance.source_dir || "source"
    end

    private_class_method :find_sources, :source_dir
  end
end
