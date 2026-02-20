# frozen_string_literal: true

require "simpress/category"
require "simpress/post"
require "simpress/generator/html"

describe Simpress::Generator::Html do
  let(:post1) { build_post_data(1, categories: [Simpress::Category.fetch("Test1")]) }
  let(:post2) { build_post_data(2, categories: [Simpress::Category.fetch("Test2")]) }
  let(:page) { build_post_data(3, layout: :page) }

  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
    allow(Simpress::Generator::Renderer::PermalinkRenderer).to receive(:generate_html)
    allow(Simpress::Generator::Renderer::IndexRenderer).to receive(:generate_index)
    allow(Simpress::Generator::Renderer::PageRenderer).to receive(:generate_html)
    allow(Simpress::Generator::Renderer::CategoryIndexRenderer).to receive(:generate_html)
    allow(Simpress::Generator::Renderer::MonthlyIndexRenderer).to receive(:generate_html)
  end

  it "正常にgenerate_htmlメソッドが呼ばれること" do
    described_class.generate([post1, post2], [page], [])
    expect(Simpress::Generator::Renderer::PermalinkRenderer).to have_received(:generate_html).exactly(2).times
    expect(Simpress::Generator::Renderer::IndexRenderer).to have_received(:generate_index)
    expect(Simpress::Generator::Renderer::PageRenderer).to have_received(:generate_html)
    expect(Simpress::Generator::Renderer::CategoryIndexRenderer).to have_received(:generate_html)
    expect(Simpress::Generator::Renderer::MonthlyIndexRenderer).to have_received(:generate_html)
  end
end
