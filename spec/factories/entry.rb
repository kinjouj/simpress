# frozen_string_literal: true

FactoryBot.define do
  factory :entry, class: "Simpress::Entry" do
    skip_create

    transient do
      categories { [] }
      tags { [] }
    end

    sequence(:id) {|id| "id-#{id}" }
    sequence(:permalink) {|n| "/test#{n}.html" }

    title { "title" }
    description { "content description" }
    date { Time.new(2025, 1, 1) }
    cover { "/images/no_image.webp" }
    index { true }
    draft { false }
    markdown { "# Test\n\ncontent\n123" }
    content { "<h1>Test</h1>\n<p>content\n123</p>" }
    toc { [] }
    taxonomies do
      {
        "categories" => categories.map {|name| build(:taxonomy, name: "categories").term(name) },
        "tags" => tags.map {|name| build(:taxonomy, name: "tags").term(name) }
      }
    end

    initialize_with { new(attributes) }
  end
end
