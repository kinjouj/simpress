# frozen_string_literal: true

module Simpress
  module Renderer
    MODE = Simpress::Config.instance.mode

    def self.generate(posts, pages, categories)
      klass = const_get(MODE.to_s.capitalize)
      klass.generate(posts, pages, categories)
    end
  end
end
