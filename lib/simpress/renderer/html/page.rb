# frozen_string_literal: true

module Simpress
  module Renderer
    module Html
      class Page
        def self.build(post, paginator = nil)
          filepath = Simpress::Theme.render_page(post.permalink, post: post, paginator: paginator)
          FileUtils.touch(filepath, mtime: post.date.to_time)
        end
      end
    end
  end
end
