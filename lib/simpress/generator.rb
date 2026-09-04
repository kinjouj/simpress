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
        build_post_relations!(posts)
        Simpress::Plugin.process(posts, pages)
        Simpress::Generator::Renderer.generate(posts, pages)
        Simpress::Theme.clear
      end

      def build_post_relations!(posts)
        link_index = posts.to_h {|p| [p.permalink, p] }
        inbound = {}

        [nil, *posts, nil].each_cons(3) do |newer_post, post, older_post|
          post.prev = Simpress::Post::Link.build(older_post)
          post.next = Simpress::Post::Link.build(newer_post)

          (post.params[:links] || []).select {|url| link_index.key?(url) }.each do |permalink|
            (inbound[permalink] ||= []) << Simpress::Post::Link.new(post)
          end
          post.backlinks = (inbound[post.permalink] ||= [])
          post.freeze
        end
      end
    end
  end
end
