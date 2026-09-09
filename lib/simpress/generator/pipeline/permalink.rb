# frozen_string_literal: true

require "simpress/generator/pipeline/base"
require "simpress/logger"

module Simpress
  module Generator
    module Pipeline
      class Permalink < Simpress::Generator::Pipeline::Base
        DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :content, :toc, :next, :prev, :backlinks].freeze

        def self.generate_html(post)
          write_html(post.permalink, template: post.layout, post: post) do |file|
            File.utime(post.date, post.date, file)
            Simpress::Logger.verbose("[BUILD PAGE]: #{post.title} #{file}")
          end
        end

        def self.generate_json(post)
          write_json(post.permalink, post, keys: DATA_JSON_KEYS) do |file|
            Simpress::Logger.verbose("[BUILD PAGE]: #{post.title} #{file}")
          end
        end
      end
    end
  end
end
