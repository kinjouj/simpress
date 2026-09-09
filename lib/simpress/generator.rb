# frozen_string_literal: true

require "simpress/config"
require "simpress/generator/pipeline"
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
        Simpress::Generator::Pipeline.generate(posts, pages)
        Simpress::Theme.clear
      end

      def build_post_relations!(posts)
        link_idx = posts.to_h {|p| [p.permalink, p] }
        refs = Hash.new {|h, k| h[k] = [] }

        [nil, *posts, nil].each_cons(3) do |newer_post, post, older_post|
          post.prev = Simpress::Post::Link.build(older_post)
          post.next = Simpress::Post::Link.build(newer_post)

          (post.params[:links] || []).each {|link| refs[link] << Simpress::Post::Link.new(post) if link_idx.key?(link) }
          post.backlinks = (refs[post.permalink] ||= [])
          post.freeze
        end
      end
    end
  end
end
