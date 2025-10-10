# frozen_string_literal: true

module Simpress
  module Model
    class Post
      include Jsonable

      SCHEMA = {
        id: String,
        title: String,
        content: String,
        toc: [[ String ]],
        date: DateTime,
        permalink: %r{\A/},
        categories: [[ Simpress::Model::Category ]],
        cover: String,
        published: TrueClass,
        layout: CH::G.enum(:post, :page),
        description: [ :optional, String ]
      }.freeze

      attr_accessor :categories
      attr_reader :id,
                  :title,
                  :content,
                  :toc,
                  :date,
                  :permalink,
                  :cover,
                  :layout,
                  :published

      def initialize(params)
        CH.validate(params, SCHEMA, strict: true)
        params.each {|key, value| instance_variable_set("@#{key}", value) }
      end

      def description
        description = @description || @content
        description.gsub(%r{</?[^>]+?>}, "")
                   .tr("\s", "")
                   .tr("　", "")
                   .tr("\n", "")
                   .strip.slice(0..99)
      end

      def to_hash_without_content
        {
          id: @id,
          title: @title,
          date: @date,
          permalink: @permalink,
          categories: @categories,
          cover: @cover
        }
      end

      # :nocov:
      def exclude_jsonable
        [ :published ]
      end
      # :nocov:

      def to_s
        "#{@title}: #{@permalink}"
      end
    end
  end
end
