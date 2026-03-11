# frozen_string_literal: true

require "simpress/category"
require "simpress/post"
require "simpress/generator/json"

describe Simpress::Generator::Json do
  let(:category) { Simpress::Category.fetch("Test") }
  let(:post1) { build(:post, categories: [category]) }
  let(:post2) { build(:post, categories: [category]) }
  let(:page) { build(:post, layout: :page) }

  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return("json")
    allow(Simpress::Generator::Renderer::IndexRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::PermalinkRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::PageRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::CategoryIndexRenderer).to receive(:generate_json)
    allow(Simpress::Generator::Renderer::MonthlyIndexRenderer).to receive(:generate_json)
  end

  it "正常にgenerateメソッドが呼ばれること" do
    described_class.generate([post1, post2], nil, { test: category })
    expect(Simpress::Generator::Renderer::IndexRenderer).to have_received(:generate_json)
    expect(Simpress::Generator::Renderer::PermalinkRenderer).to have_received(:generate_json).exactly(2).times
    expect(Simpress::Generator::Renderer::PageRenderer).to have_received(:generate_json)
    expect(Simpress::Generator::Renderer::CategoryIndexRenderer).to have_received(:generate_json)
    expect(Simpress::Generator::Renderer::MonthlyIndexRenderer).to have_received(:generate_json)
  end
end
