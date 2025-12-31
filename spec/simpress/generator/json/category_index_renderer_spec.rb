# frozen_string_literal: true

require "simpress/generator/json/category_index_renderer"

describe Simpress::Generator::Json::CategoryIndexRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write)
  end

  let(:category) { Simpress::Model::Category.new("Ruby") }
  let(:post1) { build_post_data(1, date: DateTime.new(2025, 11, 1), categories: [category]) }
  let(:post2) { build_post_data(2, date: DateTime.new(2025, 12, 1), categories: [category]) }

  let(:category_posts) do
    { ruby: [post1, post2] }
  end

  it "test" do
    expect { described_class.generate(category_posts) }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).exactly(1).times
    expect(Simpress::Writer).to have_received(:write).with("/archives/category/ruby.json", category_posts[:ruby].to_json)
  end
end
