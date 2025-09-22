# frozen_string_literal: true

require "date"
require "json"
require "logger"
require "singleton"
require "psych"

require "classy_hash"
require "erubis"
require "only_blank"
require "redcarpet"
require "jsonable"
require "stringex"
require "tee"

require "simpress/config"
require "simpress/context"
require "simpress/generator"
require "simpress/generator/html"
require "simpress/generator/json"
require "simpress/model/category"
require "simpress/model/post"
require "simpress/logger"
require "simpress/markdown"
require "simpress/markdown/filter"
require "simpress/paginator"
require "simpress/paginator/index"
require "simpress/paginator/post"
require "simpress/parser"
require "simpress/parser/redcarpet"
require "simpress/parser/redcarpet/renderer"
require "simpress/plugin"
require "simpress/theme"
require "simpress/writer"

module Simpress
  def self.build
    Simpress::Plugin.load
    Simpress::Generator.generate
    # :nocov:
    yield if block_given?
    # :nocov:
  end
end
