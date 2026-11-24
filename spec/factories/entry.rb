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
    lastmod { date }
    cover { "/images/no_image.webp" }
    index { true }
    draft { false }
    markdown { "# Test\n\ncontent\n123" }
    content { "<h1>Test</h1>\n<p>content\n123</p>" }
    toc { [] }
    taxonomies { { "categories" => categories.map {|name| build(:taxonomy, name: "categories").term(name) } } }

    initialize_with { new(attributes) }
  end
end
