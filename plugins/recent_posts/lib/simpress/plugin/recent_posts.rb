# frozen_string_literal: true

require "oj"
require "simpress/plugin"
require "simpress/writer"

module Simpress
  module Plugin
    class RecentPosts
      extend Simpress::Plugin

      DATA_JSON_KEYS = [:title, :date, :permalink].freeze

      def self.run(posts, *_args)
        recent_posts = (posts || []).take(config.paginate || 5)

        case config.mode
        when "html"
          bind_context(recent_posts: recent_posts)
        when "json"
          Simpress::Writer.write("recent_posts.json", Oj.dump(recent_posts, mode: :compat, keys: DATA_JSON_KEYS))
        else
          raise "Error"
        end
      end
    end
  end
end
