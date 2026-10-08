# frozen_string_literal: true

FactoryBot.define do
  factory :term, class: "Simpress::Taxonomy::Term" do
    skip_create

    transient do
      entries { [] }
    end

    sequence(:name) {|n| "term#{n}" }
    key { nil }

    initialize_with { new(name, key: key) }

    after(:build) do |term, evaluator|
      term.entries.concat(evaluator.entries)
    end
  end
end
