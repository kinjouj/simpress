# frozen_string_literal: true

require "simpress/plugin/category_tree"

describe Simpress::Plugin::CategoryTree do
  before do
    allow(File).to receive(:exist?).and_return(false)
  end

  after do
    Simpress::Taxonomy.clear
    Simpress::Plugin.clear
  end

  describe ".run" do
    context "when mode is html" do
      before do
        allow(Simpress::Config).to receive(:mode).and_return("html")
        allow(Simpress::Context).to receive(:update)
        allow(Simpress::Theme).to receive(:render).and_return("<ul>categories</ul>")
        allow(Simpress::Taxonomy.fetch("categories")).to receive(:terms).and_return(
          {
            "ruby" => Simpress::Taxonomy::Term.new("Ruby", key: "ruby")
          }
        )
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
        allow(Simpress::Writer).to receive(:write)
        allow(Simpress::Taxonomy.fetch("categories")).to receive(:terms).and_return(
          {
            "ruby" => Simpress::Taxonomy::Term.new("Ruby", key: "ruby")
          }
        )
      end

      it "outputs categories.json" do
        described_class.run

        expect(Simpress::Writer).to have_received(:write) do |path, json|
          data = Simpress::JSON.load(json)
          expect(path).to eq "categories.json"
          expect(data.map {|category| category["key"] }).to eq ["ruby"]
          expect(data.first.keys).to match_array(described_class::KEYS.map(&:to_s))
        end
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
        allow(File).to receive(:exist?).and_return(true)
        allow(Simpress::Config).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
      end

      context "when a parent has children" do
        before do
          allow(Simpress::JSON).to receive(:load_file).and_return({ "ruby" => ["rails"] })
          allow(Simpress::Taxonomy.fetch("categories")).to receive(:terms).and_return(
            {
              "ruby" => Simpress::Taxonomy::Term.new("Ruby", key: "ruby"),
              "rails" => Simpress::Taxonomy::Term.new("Rails", key: "rails")
            }
          )
        end

        it "nests child categories under parents" do
          described_class.run

          expect(File).to have_received(:exist?).with("category_indexes.json")
          expect(Simpress::JSON).to have_received(:load_file).with("category_indexes.json")
          expect(Simpress::Theme).to have_received(:render).with(
            "sidebar_categories",
            categories: match([have_attributes(key: "ruby")])
          )
        end
      end

      context "when orders key exists" do
        before do
          allow(Simpress::Taxonomy.fetch("categories")).to receive(:terms).and_return(
            {
              "life" => Simpress::Taxonomy::Term.new("Life", key: "life"),
              "tech" => Simpress::Taxonomy::Term.new("Tech", key: "tech")
            }
          )
          allow(Simpress::JSON).to receive(:load_file).and_return({ "orders" => ["tech", "life"] })
        end

        it "reorders the root categories" do
          described_class.run

          expect(Simpress::Theme).to have_received(:render).with(
            "sidebar_categories",
            categories: match([have_attributes(key: "tech"), have_attributes(key: "life")])
          )
        end
      end

      context "when nesting and orders exist" do
        before do
          allow(Simpress::Taxonomy.fetch("categories")).to receive(:terms).and_return(
            {
              "ruby" => Simpress::Taxonomy::Term.new("Ruby", key: "ruby"),
              "rails" => Simpress::Taxonomy::Term.new("Rails", key: "rails"),
              "jruby" => Simpress::Taxonomy::Term.new("JRuby", key: "jruby"),
              "life" => Simpress::Taxonomy::Term.new("Life", key: "life")
            }
          )
          allow(Simpress::JSON).to receive(:load_file).and_return({ "ruby" => ["jruby", "rails"], "orders" => ["rails", "jruby"] })
        end

        it "reorders nested children" do
          described_class.run

          expect(Simpress::Theme).to have_received(:render).with(
            "sidebar_categories",
            categories: match(
              [
                have_attributes(key: "ruby", children: match([have_attributes(key: "rails"), have_attributes(key: "jruby")])),
                have_attributes(key: "life")
              ]
            )
          )
        end
      end
    end
  end
end
