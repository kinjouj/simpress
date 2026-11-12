# frozen_string_literal: true

require "simpress/plugin/category_tree"

describe Simpress::Plugin::CategoryTree do
  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with("category_indexes.json").and_return(false)
    allow(Simpress::Taxonomy).to receive(:fetch).with("categories").and_return(
      instance_double(Simpress::Taxonomy, terms: { "ruby" => Simpress::Taxonomy::Term.new("Ruby", key: "ruby") })
    )
  end

  after do
    Simpress::Taxonomy.clear
    Simpress::Plugin.clear
  end

  describe ".run" do
    context "when mode is html" do
      before do
        allow(Simpress::Config).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("<ul>categories</ul>")
        allow(Simpress::Context).to receive(:update)
      end

      it "binds data to the context" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with("sidebar_categories", categories: anything)
        expect(Simpress::Context).to have_received(:update).with(sidebar_categories_content: "<ul>categories</ul>")
      end
    end

    context "when mode is json" do
      before do
        allow(Simpress::Config).to receive(:mode).and_return("json")
        allow(Simpress::JSON).to receive(:dump).and_return("{}")
        allow(Simpress::Writer).to receive(:write)
      end

      it "categories.json is generated" do
        described_class.run

        expect(Simpress::JSON).to have_received(:dump).with(anything, keys: described_class::KEYS)
        expect(Simpress::Writer).to have_received(:write).with("categories.json", "{}")
      end
    end

    context "when mode is unknown" do
      before do
        allow(Simpress::Config).to receive(:mode).and_return("unknown")
      end

      it "raises an error" do
        expect { described_class.run }.to raise_error("Unknown mode: unknown")
      end
    end

    context "when category_indexes.json exists" do
      before do
        allow(Simpress::Taxonomy).to receive(:fetch).with("categories").and_return(
          instance_double(
            Simpress::Taxonomy,
            terms: { "ruby" => Simpress::Taxonomy::Term.new("Ruby", key: "ruby"), "rails" => Simpress::Taxonomy::Term.new("Rails", key: "rails") }
          )
        )
        allow(Simpress::Config).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
        allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
        allow(Simpress::JSON).to receive(:load_file).with("category_indexes.json").and_return({ "ruby" => ["rails"] })
      end

      it "nests child categories under parents" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.any? {|c| c.key == "ruby" } && cats.none? {|c| c.key == "rails" } }
        )
      end
    end

    context "when orders key exists" do
      before do
        allow(Simpress::Taxonomy).to receive(:fetch).with("categories").and_return(
          instance_double(
            Simpress::Taxonomy,
            terms: { "life" => Simpress::Taxonomy::Term.new("Life", key: "life"), "tech" => Simpress::Taxonomy::Term.new("Tech", key: "tech") }
          )
        )
        allow(Simpress::Config).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
        allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
        allow(Simpress::JSON).to receive(:load_file).with("category_indexes.json").and_return({ "orders" => ["tech", "life"] })
      end

      it "reorders the root categories" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.map(&:key) == ["tech", "life"] }
        )

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.none? {|c| c.key == "orders" } }
        )
      end
    end

    context "when nesting and orders exist" do
      before do
        allow(Simpress::Taxonomy).to receive(:fetch).with("categories").and_return(
          instance_double(
            Simpress::Taxonomy,
            terms: {
              "ruby" => Simpress::Taxonomy::Term.new("Ruby", key: "ruby"),
              "rails" => Simpress::Taxonomy::Term.new("Rails", key: "rails"),
              "sinatra" => Simpress::Taxonomy::Term.new("Sinatra", key: "sinatra"),
              "life" => Simpress::Taxonomy::Term.new("Life", key: "life")
            }
          )
        )
        allow(Simpress::Config).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
        allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
        allow(Simpress::JSON).to receive(:load_file).with("category_indexes.json").and_return(
          { "ruby" => ["sinatra", "rails"], "orders" => ["rails", "sinatra"] }
        )
      end

      it "reorders nested children" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy do |cats|
            ruby_category = cats.find {|c| c.key == "ruby" }
            ruby_category.children.map(&:key) == ["rails", "sinatra"]
          end
        )

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.map(&:key) == ["ruby", "life"] }
        )
      end
    end
  end
end
