# frozen_string_literal: true

module Simpress
  module Preprocessor
    class RecentPosts
      extend Simpress::Preprocessor

      def self.run(posts, *_args)
        return unless config.mode.to_s == "html"
        return unless Simpress::Theme.template_exist?("sidebar_recent_posts")

        bind_context(
          sidebar_recent_posts_content: Simpress::Theme.render(
            "sidebar_recent_posts",
            recent_posts: posts.take(Simpress::Config.instance.paginate || 8)
          )
        )
      end
    end
  end
end
