# frozen_string_literal: true

require "simpress/config"
require "simpress/generator/html"
require "simpress/generator/json"
require "simpress/logger"
require "simpress/parser"
require "simpress/plugin"
require "simpress/theme"

module Simpress
  module Generator
    class << self
      def generate
        posts      = []
        categories = {}
        files = Dir.glob("#{source_dir}/**/*.{markdown}")
        files.each do |file|
          data = Simpress::Parser.parse(file)
          next unless data.published

          data.categories.each do |category|
            key = category.key

            if categories[key].nil?
              categories[key] = category
            else
              categories[key].increment!
            end
          end

          Simpress::Logger.info("PARSE COMPLETE: #{file}")
          posts << data
        end

        posts, pages = posts.partition {|post| post.layout == :post }
        posts.sort_by! {|post| -post.timestamp }
        process_and_generate(posts, pages, categories)
        Simpress::Theme.clear
      end

      private

      def source_dir
        "source"
      end

      def generator
        const_get(Simpress::Config.instance.mode.to_s.capitalize, false)
      end

      def process_and_generate(posts, pages, categories)
        Simpress::Plugin.process(posts, pages, categories)
        generator.generate(posts, pages, categories)
      end
    end
  end
end
