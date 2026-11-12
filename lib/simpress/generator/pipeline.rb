# frozen_string_literal: true

require "simpress/generator/pipeline/permalink"
require "simpress/generator/pipeline/archive/entry_index"
require "simpress/generator/pipeline/archive/monthly_index"
require "simpress/generator/pipeline/archive/taxonomy_index"
require "simpress/paginator"

module Simpress
  module Generator
    module Pipeline
      def self.generate(entries)
        monthly_entries = Hash.new {|h, k| h[k] = [] }
        index_entries = []
        entries.each do |entry|
          Simpress::Generator::Pipeline::Permalink.generate(entry)
          next unless entry.index

          index_entries << entry
          monthly_entries[[entry.date.year, entry.date.month]] << entry
        end

        Simpress::Generator::Pipeline::Archive::EntryIndex.generate(index_entries)
        Simpress::Generator::Pipeline::Archive::MonthlyIndex.generate(monthly_entries)
        Simpress::Generator::Pipeline::Archive::TaxonomyIndex.generate(Simpress::Taxonomy.taxonomies)
      end
    end
  end
end
