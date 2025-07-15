# frozen_string_literal: true

module Simpress
  module Plugin
    module Preprocessor
      class CategoriesContent
        extend Simpress::Plugin::Preprocessor
        KEY = :sidebar_categories_content

        def self.priority
          999
        end

        def self.run(_, _, categories)
          return unless config.mode.to_s == "html"
          return unless Simpress::Theme.template_exist?("sidebar_categories")

          if File.exist?("category_indexes.json")
            category_indexes = JSON.load_file("category_indexes.json")
            category_indexes.each do |key, value|
              root  = categories[value]
              child = categories[key]

              if !root.nil? && !child.nil?
                root.children[key] = child
                child.moved = true
              end
            end
          end

          categories.each_key do |key|
            category = categories[key]
            categories.delete(key) if category.moved
          end

          register_context(KEY => Simpress::Theme.render("sidebar_categories", categories: categories))
        end
      end
    end
  end
end
