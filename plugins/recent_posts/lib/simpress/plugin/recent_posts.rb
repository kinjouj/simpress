# frozen_string_literal: true

module Simpress
  module Plugin
    class RecentPosts
      extend Simpress::Plugin

      def self.run(posts, *_args)
        return unless Simpress::Theme.exist?("sidebar_recent_posts")
        recent_posts = (posts || []).take(Simpress::Config.instance.paginate || 8)

        if config.mode.to_s == "html"
          bind_context(
            sidebar_recent_posts_content: Simpress::Theme.render(
              "sidebar_recent_posts",
              recent_posts: recent_posts
            )
          )
        elsif config.mode.to_s == "json"
          Simpress::Writer.write("recent_posts.json", recent_posts.to_json)
        end
      end
    end
  end
end
