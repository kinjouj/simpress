# frozen_string_literal: true

require "simpress/config"
require "simpress/generator"
require "simpress/parser/markdown"
require "dry-schema"

class SimpressCLI < Thor
  FRONT_MATTER_SCHEMA = Dry::Schema.define do
    required(:title).filled(:string)
    optional(:date).maybe { date? | time? | str? }
    optional(:permalink).maybe(:string)
    optional(:cover).maybe(:string)
    optional(:categories).maybe { str? | (array? > each(:str?)) }
    optional(:tags).maybe { str? | (array? > each(:str?)) }
    optional(:layout).maybe(:string)
    optional(:index).maybe(:bool)
    optional(:draft).maybe(:bool)
    optional(:description).maybe(:string)
  end

  desc "lint", "Lint Front Matter Markdown files under source"
  def lint
    Simpress::Generator.each_file do |file|
      front_matter, = begin
        Simpress::Parser::Markdown.parse(File.read(file))
      rescue Simpress::Errors::ParseError, Psych::SyntaxError => e
        puts "#{file}: #{e.message}"
        next
      end

      result = FRONT_MATTER_SCHEMA.call(front_matter)
      next if result.success?

      result.errors.to_h.each {|key, messages| puts "#{file}: #{key} #{messages.join(', ')}" }
    end
  end
end
