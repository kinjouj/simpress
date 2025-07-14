# frozen_string_literal: true

module Simpress
  module Renderer
    module Html
      class Post
        def self.build(post, paginator = nil)
          filepath = Simpress::Theme.render_post(post.permalink, post: post, paginator: paginator)
          FileUtils.touch(filepath, mtime: post.date.to_time)
        end
      end
    end
  end
end
