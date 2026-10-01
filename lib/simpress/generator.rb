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
      attr_reader :link_index

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

      def clear
        @link_index = nil
      end

      private

      def process_and_generate(entries)
        build_entry_relations!(entries)
        Simpress::Plugin.process(entries)
        Simpress::Generator::Pipeline.generate(entries)
        Simpress::Theme.clear
        clear
      end

      def build_entry_relations!(entries)
        @link_index = entries.to_h {|e| [e.permalink, e] }
        refs = Hash.new {|h, k| h[k] = [] }

        [nil, *entries, nil].each_cons(3) do |newer, entry, older|
          entry.load!
          entry.prev = Simpress::Entry::Link.build(older)
          entry.next = Simpress::Entry::Link.build(newer)

          entry.links.each {|link| refs[link] << Simpress::Entry::Link.new(entry) if @link_index.key?(link) }
          entry.backlinks = (refs[entry.permalink] ||= [])
          entry.freeze
        end
      end
    end
  end
end
