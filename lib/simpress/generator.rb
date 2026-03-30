# frozen_string_literal: true

require "simpress/config"
require "simpress/generator/renderer"
require "simpress/parser"
require "simpress/plugin"
require "simpress/theme"

module Simpress
  module Generator
    class << self
      def generate
        posts      = []
        pages      = []
        categories = {}
        Dir.glob("#{Simpress::Config.source_dir}/**/*.markdown") do |file|
          data = Simpress::Parser.parse(file)
          next if data.draft

          data.categories.each do |category|
            key = category.key

            if categories.key?(key)
              categories[key].increment!
            else
              categories[key] = category
            end
          end

          (data.index ? posts : pages) << data
        end

        posts.sort_by! {|post| -post.timestamp }
        process_and_generate(posts, pages, categories)
      end

      private

      def process_and_generate(posts, pages, categories)
        Simpress::Plugin.process(posts, pages, categories)
        Simpress::Generator::Renderer.generate(posts, pages, categories)
        Simpress::Theme.clear
      end
    end
  end
end
