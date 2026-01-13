# frozen_string_literal: true

require "simpress/category"
require "simpress/generator/renderer/categories_renderer"

describe Simpress::Generator::Renderer::CategoriesRenderer do
  before do
    allow(File).to receive(:write)
    allow(File).to receive(:exist?).and_return(false)
    allow(Simpress::Logger).to receive(:info)
  end

  let(:categories) { { ruby: Simpress::Category.fetch("Ruby") } }

  it "正常にgenerate_jsonメソッドが呼ばれること" do
    expect { described_class.generate_json(categories) }.not_to raise_error
    expect(File).to have_received(:write).with("public/categories.json", categories.to_json)
    expect(Simpress::Logger).to have_received(:info)
  end
end
