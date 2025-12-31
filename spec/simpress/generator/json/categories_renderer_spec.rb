# frozen_string_literal: true

require "simpress/generator/json/categories_renderer"

describe Simpress::Generator::Json::CategoriesRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write)
  end

  let(:categories) { { ruby: Simpress::Model::Category.new("Ruby") } }

  it "test" do
    expect { described_class.generate(categories) }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).exactly(1).times
    expect(Simpress::Writer).to have_received(:write).with("/categories.json", categories.to_json)
  end
end
