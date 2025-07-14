# frozen_string_literal: true

module Simpress
  module Plugin
    module Preprocessor
      class RecentPosts
        extend Simpress::Plugin::Preprocessor
        KEY = :sidebar_recent_posts_content

        def self.run(posts, *_args)
          return unless config.mode.to_s == "html"
          return unless Simpress::Theme.template_exist?("sidebar_recent_posts")

          register_context(
            KEY => Simpress::Theme.render(
              "sidebar_recent_posts",
              recent_posts: posts.take(Simpress::Config.instance.paginate || 8)
            )
          )
        end
      end
    end
  end
end
