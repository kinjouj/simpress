# frozen_string_literal: true

require "simpress/generator/pipeline/archive/taxonomy"
require "simpress/post"

describe Simpress::Generator::Pipeline::Archive::Taxonomy do
  let!(:post) do
    build(:post, categories: ["Ruby"]).tap {|post| Simpress::Taxonomy.register(post.taxonomies, post) }
  end

  let!(:taxonomies) { Simpress::Taxonomy.taxonomies }

  before do
    Simpress::Taxonomy.clear
    allow(Simpress::Logger).to receive(:verbose)
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/archives/categories/ruby/index.html")
    end

    it "renders and writes paginated html for each term" do
      described_class.generate_html(taxonomies)
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/archives/categories/ruby/index.html", "<html>content</html>")
      expect(Simpress::Logger).to have_received(:verbose).with("[BUILD CATEGORY]: public/archives/categories/ruby/index.html")
    end
  end

  describe ".generate_json" do
    let(:expected_index_json) { Simpress::JSON.dump({ posts: [post.to_h(keys: described_class::DATA_JSON_KEYS)], total_pages: 1 }) }

    before do
      allow(Simpress::Writer).to receive(:write).with("/archives/categories/ruby/1.json", anything).and_yield("public/archives/categories/ruby/1.json")
    end

    it "writes paginated json for each term" do
      described_class.generate_json(taxonomies)
      expect(Simpress::Writer).to have_received(:write).with("/archives/categories/ruby/1.json", expected_index_json)
      expect(Simpress::Logger).to have_received(:verbose).with("[BUILD CATEGORY]: public/archives/categories/ruby/1.json")
    end
  end
end
