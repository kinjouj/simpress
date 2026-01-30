# frozen_string_literal: true

require "json"
require "simpress/config"
require "simpress/plugin"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Plugin
    class RecentPosts
      extend Simpress::Plugin

      def self.run(posts, *_args)
        recent_posts = (posts || []).take(config.paginate || 5)

        case config.mode
        when "html"
          bind_context(recent_posts: recent_posts)
        when "json"
          Simpress::Writer.write("recent_posts.json", recent_posts.to_json)
        else
          raise "Error"
        end
      end
    end
  end
end
