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

  describe ".run" do
    context "when mode is html" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("<ul>categories</ul>")
        allow(Simpress::Context).to receive(:update)
      end

      it "renders sidebar_categories template with nested categories" do
        described_class.run([], [])
        expect(Simpress::Theme).to have_received(:render).with("sidebar_categories", categories: anything)
      end

      it "binds the rendered content to context" do
        described_class.run([], [])
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
        described_class.run([], [])
        expect(Simpress::Writer).to have_received(:write).with("categories.json", "{}")
      end

      it "dumps nested categories with permitted keys" do
        described_class.run([], [])
        expect(Simpress::JSON).to have_received(:dump).with(anything, keys: described_class::KEYS)
      end
    end

    context "when mode is unknown" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("unknown")
      end

      it "raises an error" do
        expect { described_class.run([], []) }.to raise_error("Error")
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
        described_class.run([], [])

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.key?("ruby") && !cats.key?("rails") }
        )
      end
    end
  end
end
