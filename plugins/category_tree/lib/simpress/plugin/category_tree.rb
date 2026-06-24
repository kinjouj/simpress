# frozen_string_literal: true

require "simpress/json"
require "simpress/plugin"
require "simpress/taxonomy"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Plugin
    class CategoryTree
      extend Simpress::Plugin

      KEYS = [:key, :name, :count, :children].freeze
      ORDER_KEY = "orders"

      def self.run(*)
        nested_categories = build_nested_categories

        case config.mode
        when "html"
          process_html(nested_categories)
        when "json"
          process_json(nested_categories)
        else
          raise "Unknown mode: #{config.mode}"
        end
      end

      def self.build_nested_categories
        nested = Simpress::Taxonomy.fetch("categories").terms.each_with_object({}) {|(_, term), hash| hash[term.key] = term.dup }
        return nested.values unless File.exist?("category_indexes.json")

        category_indexes = Simpress::JSON.load_file("category_indexes.json")
        order = category_indexes.delete(ORDER_KEY)

        moved_keys = category_indexes.each_with_object(Set.new) do |(key, values), acc|
          root = nested[key] or next
          values.each do |value|
            child = nested[value] or next
            root.children << child
            acc << value
          end
        end

        categories = nested.except(*moved_keys).values
        order ? sort_categories(categories, order) : categories
      end

      def self.sort_categories(categories, order)
        priority = order.each_with_index.to_h
        sorted = categories.sort_by.with_index {|term, i| [priority[term.key] || order.size, i] }
        sorted.each {|term| term.children.replace(sort_categories(term.children, order)) }
      end

      def self.process_html(categories)
        bind_context(sidebar_categories_content: Simpress::Theme.render("sidebar_categories", categories: categories))
      end

      def self.process_json(categories)
        Simpress::Writer.write("categories.json", Simpress::JSON.dump(categories, keys: KEYS))
      end

      private_class_method :build_nested_categories, :sort_categories, :process_html, :process_json
    end
  end
end
