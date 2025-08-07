# frozen_string_literal: true

module Simpress
  module Parser
    module Redcarpet
      class Markdown < ::Redcarpet::Markdown
        def render(data)
          body = super
          [ body, renderer.primary_image, renderer.toc ]
        end
      end
    end
  end
end
