# frozen_string_literal: true

require "simpress/entry"
require "simpress/taxonomy"
require "simpress/generator/pipeline/archive/taxonomy_index"

describe Simpress::Generator::Pipeline::Archive::TaxonomyIndex do
  before do
    Simpress::Taxonomy.clear
    allow(Simpress::Config).to receive(:taxonomies).and_return({ types: ["categories"] })
    allow(Simpress::Config).to receive(:logging).and_return(true)
  end

  let!(:entry) do
    build(:entry, categories: ["Ruby"]).tap {|e| Simpress::Taxonomy.register(e.taxonomies, e) }
  end

  let!(:taxonomies) do
    Simpress::Taxonomy.taxonomies
  end

  after do
    Simpress::Taxonomy.clear
    Simpress::Logger.clear
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/archives/categories/ruby/index.html")
    end

    it "outputs /archives/categories/ruby/index.html" do
      expect { described_class.generate_html(taxonomies) }.to output(%r{\[BUILD TAXONOMY\]: public/archives/categories/ruby/index\.html}).to_stdout_from_any_process
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/archives/categories/ruby/index.html", "<html>content</html>")
    end
  end

  describe ".generate_json" do
    let(:expected_index_json) do
      Simpress::JSON.dump({ entries: [entry], total_pages: 1 }, keys: described_class::DATA_JSON_KEYS)
    end

    before do
      allow(Simpress::Writer).to receive(:write).with("/archives/categories/ruby/1.json", anything).and_yield("public/archives/categories/ruby/1.json")
    end

    it "outputs /archives/categories/ruby/1.json" do
      expect { described_class.generate_json(taxonomies) }.to output(%r{\[BUILD TAXONOMY\]: public/archives/categories/ruby/1\.json}).to_stdout_from_any_process
      expect(Simpress::Writer).to have_received(:write).with("/archives/categories/ruby/1.json", expected_index_json)
    end
  end
end
