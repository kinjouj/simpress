# frozen_string_literal: true

module Simpress
  module Renderer
    module Html
      class Page
        def self.build(post)
          result = Simpress::Theme.render("page", post: post)
          Simpress::Writer.write(post.permalink, result) do |filepath|
            FileUtils.touch(filepath, mtime: post.date.to_time)
          end
        end
      end
    end
  end
end
