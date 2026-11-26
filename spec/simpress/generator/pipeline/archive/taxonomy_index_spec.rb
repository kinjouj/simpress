# frozen_string_literal: true

require "simpress/entry"
require "simpress/taxonomy"
require "simpress/generator/pipeline/archive/taxonomy_index"

describe Simpress::Generator::Pipeline::Archive::TaxonomyIndex do
  before do
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
      expect { described_class.generate_html(taxonomies) }.to output(%r{\[BUILD TAXONOMY\]: public/archives/categories/ruby/index\.html}).to_stdout
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/archives/categories/ruby/index.html", "<html>content</html>")
    end
  end

  describe ".generate_json" do
    before do
      allow(Simpress::Writer).to receive(:write).and_yield("public/archives/categories/ruby/1.json")
    end

    it "outputs /archives/categories/ruby/1.json" do
      expect { described_class.generate_json(taxonomies) }.to output(%r{\[BUILD TAXONOMY\]: public/archives/categories/ruby/1\.json}).to_stdout
      expect(Simpress::Writer).to have_received(:write) do |path, json|
        expect(path).to eq "/archives/categories/ruby/1.json"

        data = Simpress::JSON.load(json)
        expect(data["total_pages"]).to eq 1
        expect(data["entries"].map {|e| e["permalink"] }).to eq [entry.permalink]
        expect(data["entries"].first.keys).to match_array(described_class::DATA_JSON_KEYS.map(&:to_s))
      end
    end
  end
end
