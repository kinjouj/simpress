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
      attr_reader :link_index

      def each_file(&block)
        raise ArgumentError, "block required" unless block

        Dir.glob("#{Simpress::Config.source_dir}/**/*.markdown", &block)
      end

      def generate
        posts = []
        pages = []
        each_file do |file|
          post = Simpress::Parser.parse(file)
          next if post.nil? || post.draft

          post.register_taxonomies!

          if post.index
            posts << post
          else
            post.load!
            pages << post
          end
        end

        posts.sort_by! {|post| -post.date.to_i }
        process_and_generate(posts, pages)
      end

      def clear
        @link_index = nil
      end

      private

      def process_and_generate(posts, pages)
        build_post_relations!(posts)
        Simpress::Plugin.process(posts, pages)
        Simpress::Generator::Pipeline.generate(posts, pages)
        Simpress::Theme.clear
        clear
      end

      def build_post_relations!(posts)
        @link_index = posts.to_h {|p| [p.permalink, p] }
        refs = Hash.new {|h, k| h[k] = [] }

        [nil, *posts, nil].each_cons(3) do |newer_post, post, older_post|
          post.load!
          post.prev = Simpress::Post::Link.build(older_post)
          post.next = Simpress::Post::Link.build(newer_post)

          post.links.each {|link| refs[link] << Simpress::Post::Link.new(post) if @link_index.key?(link) }
          post.backlinks = (refs[post.permalink] ||= [])
          post.freeze
        end
      end
    end
  end
end
