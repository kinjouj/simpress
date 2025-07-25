# frozen_string_literal: true

module Simpress
  module Renderer
    module Html
      class Post
        def self.build(post, paginator)
          result = Simpress::Theme.render("post", post: post, paginator: paginator)
          Simpress::Writer.write(post.permalink, result) do |filepath|
            FileUtils.touch(filepath, mtime: post.date.to_time)
          end
        end
      end
    end
  end
end
