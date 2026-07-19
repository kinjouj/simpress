# frozen_string_literal: true

require "oj"

Oj.default_options = {
  mode: :custom,
  use_to_json: true,
  use_as_json: true,
  time_format: :xmlschema
}

module Simpress
  module JSON
    class << self
      def load_file(data, options = {})
        Oj.load_file(data, **options)
      end

      def load(data, options = {})
        Oj.load(data, **options)
      end

      def dump(obj, options = {})
        Oj.dump(obj, **options)
      end

      def encode(data)
        Oj.dump(data, mode: :rails, escape_mode: :xss_safe)
      end
    end

    module Serializable
      def as_json(options = {})
        to_h(options)
      end

      def to_json(options = {})
        Simpress::JSON.dump(as_json(options))
      end
    end
  end
end
