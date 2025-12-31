# frozen_string_literal: true

require "simpress/generator/html/category_index_renderer"

describe Simpress::Generator::Html::CategoryIndexRenderer do
  let(:category) { Simpress::Model::Category.new("Test") }

  let(:post1) do
    build_post_data(1, date: DateTime.new(2025, 11, 15), categories: [category])
  end

  let(:post2) do
    build_post_data(2, date: DateTime.new(2025, 12, 1), categories: [category])
  end

  let(:category_posts) { { category => [post1, post2] } }

  before do
    allow(Simpress::Generator::Html::IndexRenderer).to receive(:generate)
  end

  it "sorts posts in descending order by date" do
    expect { described_class.generate(category_posts) }.not_to raise_error
    expect(Simpress::Generator::Html::IndexRenderer).to have_received(:generate).with([post2, post1], anything, "Test")
  end
end
