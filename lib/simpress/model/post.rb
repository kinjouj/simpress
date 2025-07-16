# frozen_string_literal: true

module Simpress
  module Model
    class Post
      include Jsonable

      SCHEMA = {
        title: String,
        content: String,
        toc: Array,
        date: DateTime,
        permalink: %r{\A/},
        categories: [[Simpress::Model::Category]],
        cover: %r{\A\/},
        published: TrueClass,
        layout: CH::G.enum(:post, :page),
        description: [ :optional, String ]
      }.freeze

      attr_writer :categories
      attr_reader :title,
                  :content,
                  :toc,
                  :date,
                  :permalink,
                  :categories,
                  :cover,
                  :layout,
                  :published

      def initialize(params)
        CH.validate(params, SCHEMA, strict: true)
        bind_values(params)
      end

      def description
        description = @description || @content
        description.gsub(%r{</?[^>]+?>}, "").strip.slice(0..99).tr("\s", "").tr("　", "").tr("\n", "")
      end

      private

      def bind_values(values)
        values.each {|key, value| instance_variable_set("@#{key}", value) }
      end
    end
  end
end
