# frozen_string_literal: true

require "simpress/generator/renderer/archive/taxonomy_renderer"
require "simpress/post"
require "simpress/taxonomy"

describe Simpress::Generator::Renderer::Archive::TaxonomyRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write).and_yield(anything)
    Simpress::Taxonomy.clear
  end

  let(:category) { Simpress::Taxonomy.fetch("categories").term("Ruby") }
  let(:post1) { build(:post, id: 1, taxonomies: { categories: [category] }) }
  let(:post2) { build(:post, id: 2, taxonomies: { categories: [category] }) }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("category index")
      category.posts << post1
      category.posts << post2
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      described_class.generate_html(Simpress::Taxonomy.taxonomies)
      expect(Simpress::Writer).to have_received(:write).with("/archives/categories/ruby/index.html", "category index")
      expect(Simpress::Logger).to have_received(:info)
      expect(Simpress::Theme).to have_received(:render)
    end
  end

  describe ".generate_json" do
    before do
      allow(Simpress::Config.instance).to receive(:paginate).and_return(1)
      category.posts << post1
      category.posts << post2
    end

    let(:keys) { described_class::DATA_JSON_KEYS }

    it "正常にgenerate_jsonメソッドが呼ばれること" do
      described_class.generate_json(Simpress::Taxonomy.taxonomies)
      expect(Simpress::Writer).to have_received(:write).with(
        "/archives/categories/ruby/1.json",
        Simpress::JSON.dump([post1], keys: keys)
      )
      expect(Simpress::Writer).to have_received(:write).with(
        "/archives/categories/ruby/2.json",
        Simpress::JSON.dump([post2], keys: keys)
      )
      expect(Simpress::Writer).to have_received(:write).with(
        "/archives/categories/ruby/meta.json",
        anything
      )
      expect(Simpress::Logger).to have_received(:info).exactly(3)
    end
  end
end
