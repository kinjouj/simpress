# frozen_string_literal: true

module Simpress
  module Errors
    class BlockRequiredError < StandardError; end
    class PageNotFoundError < StandardError; end
    class UnknownModeError < StandardError; end
    class FileExistsError < StandardError; end
    class ParseError < StandardError; end
    class ConfigError < StandardError; end
  end
end
