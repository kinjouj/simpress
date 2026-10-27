# frozen_string_literal: true

FactoryBot.define do
  factory :taxonomy, class: "Simpress::Taxonomy" do
    skip_create

    name { "categories" }

    initialize_with { FactoryBot.factories.find(:taxonomy).build_class.fetch(name) }
  end
end
