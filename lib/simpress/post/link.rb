# frozen_string_literal: true

require "delegate"
require "simpress/json"

module Simpress
  class Post
    class Link < SimpleDelegator
      include Simpress::JSON::Serializable

      def self.build(post)
        return nil if post.nil?

        new(post)
      end

      def to_h(_options = {})
        { id: id, title: title, permalink: permalink }
      end
    end
  end
end
