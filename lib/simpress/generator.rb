# frozen_string_literal: true

module Simpress
  module Generator
    class << self
      def generate
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
        generator_by_mode.generate(posts, pages, categories)
        Simpress::Theme.clear
      end

      def generator_by_mode
        const_get(Simpress::Config.instance.mode.to_s.capitalize, false)
      end

      def find_sources
        Dir["#{source_dir}/**/*.{md,markdown}"]
      end

      def source_dir
        Simpress::Config.instance.source_dir || "source"
      end
    end

    private_class_method :generator_by_mode, :find_sources, :source_dir
  end
end
