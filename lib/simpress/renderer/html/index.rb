# frozen_string_literal: true

module Simpress
  module Renderer
    module Html
      class Index
        def self.build(posts, paginator, key = nil)
          result = Simpress::Theme.render("index", key: key, posts: posts, paginator: paginator)
          Simpress::Writer.write(paginator.current_page, result)
        end
      end
    end
  end
end
