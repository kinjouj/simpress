# frozen_string_literal: true

require "pathling"
require "simpress/config"
require "simpress/json"

module Simpress
  module Theme
    module Helper
      def json_encode(data)
        Simpress::JSON.encode(data)
      end

      def canonical(path)
        "#{Simpress::Config.instance.host.chomp('/')}#{uri(path)}"
      end

      def uri(path)
        Pathling.wrap(path).with_ext("html")
      end

      def link_to(text, path, **options)
        attrs     = { href: path, **options }
        attrs_str = attrs.map {|k, v| %(#{k}="#{v}") }.join(" ")
        %(<a #{attrs_str}>#{text}</a>)
      end
    end
  end
end
