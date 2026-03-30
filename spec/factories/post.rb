# frozen_string_literal: true

FactoryBot.define do
  factory :post, class: "Simpress::Post" do
    skip_create

    sequence(:id) {|id| "id-#{id}" }
    sequence(:permalink) {|n| "/test#{n}.html" }

    title { "title" }
    description { "content description" }
    content { "<p>content\n123</p>" }
    toc { [] }
    date { Time.new(2025, 1, 1) }
    categories { [] }
    cover { "/images/no_image.webp" }
    index { true }
    draft { false }
    markdown { "# Test" }

    initialize_with { new(attributes) }
  end
end
