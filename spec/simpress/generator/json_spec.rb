# frozen_string_literal: true

require "simpress/category"
require "simpress/post"
require "simpress/generator/json"

describe Simpress::Generator::Json do
  let(:category) { Simpress::Category.new("Test") }
  let(:post1) { build_post_data(1, categories: [category]) }
  let(:post2) { build_post_data(2, categories: [category]) }
  let(:page) { build_post_data(4, layout: :page) }

  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return(:json)
    allow(Simpress::Generator::Renderer::IndexRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::PermalinkRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::PageRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::CategoryIndexRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::MonthlyIndexRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::CategoriesRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::PageInfoRenderer).to receive(:generate_json)
  end

  it "正常にgenerateメソッドが呼ばれること" do
    expect { described_class.generate([post1, post2], nil, { test: category }) }.not_to raise_error
    expect(Simpress::Generator::Renderer::IndexRenderer).to have_received(:generate_json)
    expect(Simpress::Generator::Renderer::PermalinkRenderer).to have_received(:generate_json).exactly(2).times
    expect(Simpress::Generator::Renderer::PageRenderer).to have_received(:generate_json)
    expect(Simpress::Generator::Renderer::CategoryIndexRenderer).to have_received(:generate_json)
    expect(Simpress::Generator::Renderer::MonthlyIndexRenderer).to have_received(:generate_json)
    expect(Simpress::Generator::Renderer::CategoriesRenderer).to have_received(:generate_json)
    expect(Simpress::Generator::Renderer::PageInfoRenderer).to have_received(:generate_json)
  end
end
