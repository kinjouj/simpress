# frozen_string_literal: true

require "date"
require "singleton"
require "psych"

require "classy_hash"
require "erubis"
require "redcarpet"
require "jsonable"

require "simpress/config"
require "simpress/context"
require "simpress/model/category"
require "simpress/model/post"
require "simpress/logger"
require "simpress/markdown"
require "simpress/paginator/index"
require "simpress/paginator/post"
require "simpress/parser"
require "simpress/parser/redcarpet"
require "simpress/parser/redcarpet/filter"
require "simpress/parser/redcarpet/filter/inline_note"
require "simpress/parser/redcarpet/markdown"
require "simpress/parser/redcarpet/renderer"
require "simpress/plugin"
require "simpress/plugin/preprocessor"
require "simpress/plugin/preprocessor/html_loader"
require "simpress/plugin/preprocessor/recent_posts"
require "simpress/processor"
require "simpress/renderer"
require "simpress/renderer/html"
require "simpress/renderer/html/post"
require "simpress/renderer/html/index"
require "simpress/renderer/html/page"
require "simpress/renderer/json"
require "simpress/theme"

module Simpress
  def self.build
    Simpress::Plugin.load
    Simpress::Processor.generate
  end
end
