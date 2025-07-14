# frozen_string_literal: true

module Simpress
  module Renderer
    def self.generate(*args)
      klass = const_get(Simpress::Config.instance.mode.to_s.capitalize)
      klass.generate(args)
    end
  end
end
