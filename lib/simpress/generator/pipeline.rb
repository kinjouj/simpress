# frozen_string_literal: true

require "simpress/generator/pipeline/permalink"
require "simpress/generator/pipeline/archive/monthly"
require "simpress/generator/pipeline/archive/entry_index"
require "simpress/generator/pipeline/archive/taxonomy"
require "simpress/paginator"

module Simpress
  module Generator
    module Pipeline
      def self.generate(entries)
        monthly_archives = Hash.new {|h, k| h[k] = [] }
        index_entries = []
        entries.each do |entry|
          Simpress::Generator::Pipeline::Permalink.generate(entry)
          next unless entry.index

          index_entries << entry
          monthly_archives[Time.new(entry.date.year, entry.date.month)] << entry
        end

        Simpress::Generator::Pipeline::Archive::EntryIndex.generate(index_entries)
        Simpress::Generator::Pipeline::Archive::Monthly.generate(monthly_archives)
        Simpress::Generator::Pipeline::Archive::Taxonomy.generate(Simpress::Taxonomy.taxonomies)
      end
    end
  end
end
