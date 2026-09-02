# frozen_string_literal: true

require "simpress/config"
require "simpress/generator/renderer"
require "simpress/parser"
require "simpress/plugin"
require "simpress/post"
require "simpress/theme"

module Simpress
  module Generator
    class << self
      def generate
        posts = []
        pages = []
        Dir.glob("#{Simpress::Config.source_dir}/**/*.markdown") do |file|
          post = Simpress::Parser.parse(file)
          next if post.nil? || post.draft

          post.register_taxonomies!
          (post.index ? posts : pages) << post
        end

        posts.sort_by! {|post| -post.date.to_i }
        process_and_generate(posts, pages)
      end

      private

      def process_and_generate(posts, pages)
        build_backlinks(posts)
        Simpress::Plugin.process(posts, pages)
        Simpress::Generator::Renderer.generate(posts, pages)
        Simpress::Theme.clear
      end

      def build_backlinks(posts)
        link_index = posts.to_h {|p| [p.permalink, p] }
        inbound = {}
        posts.each do |post|
          post.links.select {|link| link_index.key?(link) }.each {|link| (inbound[link] ||= []) << Simpress::Post::PostLink.new(post) }
          post.backlinks = (inbound[post.permalink] ||= [])
        end
      end
    end
  end
end
