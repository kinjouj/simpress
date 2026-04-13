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
        posts = []
        pages = []
        Dir.glob("#{Simpress::Config.source_dir}/**/*.markdown") do |file|
          data = Simpress::Parser.parse(file)
          next if data.nil? || data.draft

          (data.index ? posts : pages) << data
        end

        posts.sort_by! {|post| -post.timestamp }
        process_and_generate(posts, pages)
      end

      private

      def process_and_generate(posts, pages)
        Simpress::Plugin.process(posts, pages)
        Simpress::Generator::Renderer.generate(posts, pages)
        Simpress::Theme.clear
      end
    end
  end
end
