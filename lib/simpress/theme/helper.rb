# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"
require "simpress/json"
require "simpress/uri"

module Simpress
  module Theme
    module Helper
      class << self
        def register(mod)
          include(mod)

          Simpress::Logger.debug("REGISTER HELPER: #{mod}")
        end
      end

      module Plugin
        def self.included(base)
          Simpress::Theme::Helper.register(base)
        end
      end

      module Default
        def encode_json(data)
          Simpress::JSON.encode(data)
        end

        def canonical(path)
          "#{Simpress::Config.instance.host.chomp('/')}#{uri(path)}"
        end

        def uri(path)
          Simpress::Uri.wrap(path).with_ext("html")
        end

        def flatten_toc(toc)
          toc.flat_map do |heading|
            children = heading[:children].map {|child| { id: child[:id], text: child[:text], depth: 1 } }
            [{ id: heading[:id], text: heading[:text], depth: 0 }] + children
          end
        end
      end

      include Simpress::Theme::Helper::Default
    end
  end
end
