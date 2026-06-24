# frozen_string_literal: true

require "simpress/plugin/category_tree"

describe Simpress::Plugin::CategoryTree do
  let(:term) { Simpress::Taxonomy::Term.new("Ruby", key: "ruby") }
  let(:taxonomy) { instance_double(Simpress::Taxonomy, terms: { "ruby" => term }) }

  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with("category_indexes.json").and_return(false)
    allow(Simpress::Taxonomy).to receive(:fetch).with("categories").and_return(taxonomy)
  end

  after do
    Simpress::Taxonomy.clear
  end

  describe ".run" do
    context "when mode is html" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("<ul>categories</ul>")
        allow(Simpress::Context).to receive(:update)
      end

      it "renders sidebar_categories template with nested categories" do
        described_class.run
        expect(Simpress::Theme).to have_received(:render).with("sidebar_categories", categories: anything)
      end

      it "binds the rendered content to context" do
        described_class.run
        expect(Simpress::Context).to have_received(:update).with(sidebar_categories_content: "<ul>categories</ul>")
      end
    end

    context "when mode is json" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("json")
        allow(Simpress::JSON).to receive(:dump).and_return("{}")
        allow(Simpress::Writer).to receive(:write)
      end

      it "writes categories.json" do
        described_class.run
        expect(Simpress::Writer).to have_received(:write).with("categories.json", "{}")
      end

      it "dumps nested categories with permitted keys" do
        described_class.run
        expect(Simpress::JSON).to have_received(:dump).with(anything, keys: described_class::KEYS)
      end
    end

    context "when mode is unknown" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("unknown")
      end

      it "raises an error" do
        expect { described_class.run }.to raise_error("Unknown mode: unknown")
      end
    end

    context "when category_indexes.json exists" do
      let(:rails_term) { Simpress::Taxonomy::Term.new("Rails", key: "rails") }
      let(:taxonomy)   { instance_double(Simpress::Taxonomy, terms: { "ruby" => term, "rails" => rails_term }) }

      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
        allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
        allow(Simpress::JSON).to receive(:load_file).with("category_indexes.json").and_return({ "ruby" => ["rails"] })
      end

      it "nests child categories under their parent and removes them from root" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.any? {|c| c.key == "ruby" } && cats.none? {|c| c.key == "rails" } }
        )
      end
    end

    context "when category_indexes.json contains an orders key" do
      let(:life_term) { Simpress::Taxonomy::Term.new("Life", key: "life") }
      let(:tech_term) { Simpress::Taxonomy::Term.new("Tech", key: "tech") }
      let(:taxonomy)  { instance_double(Simpress::Taxonomy, terms: { "life" => life_term, "tech" => tech_term }) }

      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
        allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
        allow(Simpress::JSON).to receive(:load_file).with("category_indexes.json").and_return(
          { "orders" => ["tech", "life"] }
        )
      end

      it "sorts root categories according to the orders list" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.map(&:key) == ["tech", "life"] }
        )
      end

      it "does not treat the orders key as a parent-child relationship" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.none? {|c| c.key == "orders" } }
        )
      end
    end

    context "when category_indexes.json has both nesting and orders" do
      let(:rails_term) { Simpress::Taxonomy::Term.new("Rails", key: "rails") }
      let(:sinatra_term) { Simpress::Taxonomy::Term.new("Sinatra", key: "sinatra") }
      let(:life_term) { Simpress::Taxonomy::Term.new("Life", key: "life") }
      let(:taxonomy) do
        instance_double(
          Simpress::Taxonomy,
          terms: { "ruby" => term, "rails" => rails_term, "sinatra" => sinatra_term, "life" => life_term }
        )
      end

      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
        allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
        allow(Simpress::JSON).to receive(:load_file).with("category_indexes.json").and_return(
          { "ruby" => ["sinatra", "rails"], "orders" => ["rails", "sinatra"] }
        )
      end

      it "sorts nested children according to the orders list" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy do |cats|
            ruby_category = cats.find {|c| c.key == "ruby" }
            ruby_category.children.map(&:key) == ["rails", "sinatra"]
          end
        )
      end

      it "sorts root categories that are not in the orders list to the end" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.map(&:key) == ["ruby", "life"] }
        )
      end
    end
  end
end
