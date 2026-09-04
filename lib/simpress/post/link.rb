# frozen_string_literal: true

require "forwardable"
require "simpress/json"

module Simpress
  class Post
    class Link
      include Simpress::JSON::Serializable
      extend Forwardable

      def_delegators :@post, :id, :title, :permalink

      def self.build(post)
        return nil if post.nil?

        new(post)
      end

      def initialize(post)
        @post = post
      end

      def to_h(_options = {})
        { id: id, title: title, permalink: permalink }
      end
    end
  end
end
