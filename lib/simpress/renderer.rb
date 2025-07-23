# frozen_string_literal: true

module Simpress
  module Renderer
    def self.generate(posts, pages, categories)
      klass = const_get(Simpress::Config.instance.mode.to_s.capitalize)
      klass.generate(posts, pages, categories)
    end
  end
end
