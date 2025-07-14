# frozen_string_literal: true

module Simpress
  module Renderer
    module Html
      class Index
        def self.build(posts, paginator, key = nil)
          Simpress::Theme.render_index(paginator.current_page, key: key, posts: posts, paginator: paginator)
        end
      end
    end
  end
end
