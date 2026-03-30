# frozen_string_literal: true

require "simpress/json"
require "simpress/plugin"
require "simpress/writer"

module Simpress
  module Plugin
    class RecentPosts
      extend Simpress::Plugin

      KEYS = [:title, :permalink].freeze

      def self.run(posts, *_args)
        recent_posts = Array(posts).take(5)

        case config.mode
        when "html"
          bind_context(recent_posts: recent_posts)
        when "json"
          Simpress::Writer.write("recent_posts.json", Simpress::JSON.dump(recent_posts, keys: KEYS))
        else
          raise "Error"
        end
      end
    end
  end
end
