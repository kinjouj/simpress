# frozen_string_literal: true

require "simpress/json"
require "simpress/plugin"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Plugin
    class CategoriesContent
      extend Simpress::Plugin

      KEYS = [:key, :name, :count, :children].freeze

      def self.run(_, _, categories)
        nested_categories = categories.transform_values(&:dup)

        if File.exist?("category_indexes.json")
          category_indexes = Simpress::JSON.load_file("category_indexes.json")
          moved_keys = category_indexes.each_with_object(Set.new) do |(key, values), acc|
            root = nested_categories[key]
            next unless root

            values.each do |value|
              child = nested_categories[value]
              next unless child

              root.children[value] = child
              acc << value
            end
          end

          moved_keys.each {|k| nested_categories.delete(k) }
        end

        case config.mode
        when "html"
          sidebar_categories_content = Simpress::Theme.render("sidebar_categories", categories: nested_categories)
          bind_context(sidebar_categories_content: sidebar_categories_content)
        when "json"
          Simpress::Writer.write("categories.json", Simpress::JSON.dump(nested_categories, keys: KEYS))
        else
          raise "Error"
        end
      end
    end
  end
end
