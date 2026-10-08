# frozen_string_literal: true

require "simpress/config"
require "simpress/generator/pipeline"
require "simpress/parser"
require "simpress/plugin"
require "simpress/entry"
require "simpress/taxonomy"
require "simpress/theme"

module Simpress
  module Generator
    class << self
      def each_file(&block)
        raise "block is required" unless block

        Dir.glob("#{Simpress::Config.source_dir}/**/*.markdown", &block)
      end

      def generate
        entries = []
        each_file do |file|
          entry = Simpress::Parser.parse(file)
          next if entry.nil? || entry.draft

          Simpress::Taxonomy.register(entry.taxonomies, entry)
          entries << entry
        end

        entries.sort_by! {|entry| -entry.date.to_i }
        process_and_generate(entries)
      end

      private

      def process_and_generate(entries)
        build_entry_relations!(entries)
        Simpress::Plugin.process(entries)
        Simpress::Generator::Pipeline.generate(entries)
        Simpress::Theme.clear
      end

      def build_entry_relations!(entries)
        [nil, *entries.select(&:index), nil].each_cons(3) do |newer, entry, older|
          entry.prev = Simpress::Entry::Link.build(older)
          entry.next = Simpress::Entry::Link.build(newer)
        end
      end
    end
  end
end
