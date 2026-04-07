# frozen_string_literal: true

require "simpress/generator/renderer"
require "simpress/post"
require "simpress/taxonomy"

describe Simpress::Generator::Renderer do
  let(:post1) { build(:post, taxonomies: { categories: [Simpress::Taxonomy::Term.new("Test1")] }) }
  let(:post2) { build(:post, id: 2, taxonomies: { categories: [Simpress::Taxonomy::Term.new("Test2")] }) }
  let(:page) { build(:post, id: 3, index: false) }

  context "modeがhtmlの場合" do
    before do
      allow(Simpress::Config.instance).to receive(:mode).and_return("html")
      allow(Simpress::Generator::Renderer::PermalinkRenderer).to receive(:generate_html)
      allow(Simpress::Generator::Renderer::PageRenderer).to receive(:generate_html)
      allow(Simpress::Generator::Renderer::Archive::PostIndexRenderer).to receive(:generate_html)
      allow(Simpress::Generator::Renderer::Archive::MonthlyRenderer).to receive(:generate_html)
      allow(Simpress::Generator::Renderer::Archive::TaxonomyRenderer).to receive(:generate_html)
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      described_class.generate([post1, post2], [page])
      expect(Simpress::Generator::Renderer::PermalinkRenderer).to have_received(:generate_html).exactly(2).times
      expect(Simpress::Generator::Renderer::PageRenderer).to have_received(:generate_html)
      expect(Simpress::Generator::Renderer::Archive::PostIndexRenderer).to have_received(:generate_html)
      expect(Simpress::Generator::Renderer::Archive::MonthlyRenderer).to have_received(:generate_html)
      expect(Simpress::Generator::Renderer::Archive::TaxonomyRenderer).to have_received(:generate_html)
    end
  end

  context "modeがjsonの場合" do
    before do
      allow(Simpress::Config.instance).to receive(:mode).and_return("json")
      allow(Simpress::Generator::Renderer::PermalinkRenderer).to receive(:generate_json)
      allow(Simpress::Generator::Renderer::PageRenderer).to receive(:generate_json)
      allow(Simpress::Generator::Renderer::Archive::PostIndexRenderer).to receive(:generate_json)
      allow(Simpress::Generator::Renderer::Archive::MonthlyRenderer).to receive(:generate_json)
      allow(Simpress::Generator::Renderer::Archive::TaxonomyRenderer).to receive(:generate_json)
    end

    it "正常にgenerate_jsonメソッドが呼ばれること" do
      described_class.generate([post1, post2], [page])
      expect(Simpress::Generator::Renderer::PermalinkRenderer).to have_received(:generate_json).exactly(2).times
      expect(Simpress::Generator::Renderer::PageRenderer).to have_received(:generate_json)
      expect(Simpress::Generator::Renderer::Archive::PostIndexRenderer).to have_received(:generate_json)
      expect(Simpress::Generator::Renderer::Archive::MonthlyRenderer).to have_received(:generate_json)
      expect(Simpress::Generator::Renderer::Archive::TaxonomyRenderer).to have_received(:generate_json)
    end
  end
end
