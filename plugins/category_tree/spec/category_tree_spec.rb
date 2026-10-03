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
    Simpress::Plugin.clear
  end

  describe ".run" do
    context "modeがhtmlの場合" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("<ul>categories</ul>")
        allow(Simpress::Context).to receive(:update)
      end

      it "ネストされたカテゴリでsidebar_categoriesテンプレートをレンダリングする" do
        described_class.run
        expect(Simpress::Theme).to have_received(:render).with("sidebar_categories", categories: anything)
      end

      it "レンダリング結果をコンテキストにバインドする" do
        described_class.run
        expect(Simpress::Context).to have_received(:update).with(sidebar_categories_content: "<ul>categories</ul>")
      end
    end

    context "modeがjsonの場合" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("json")
        allow(Simpress::JSON).to receive(:dump).and_return("{}")
        allow(Simpress::Writer).to receive(:write)
      end

      it "categories.jsonを書き出す" do
        described_class.run
        expect(Simpress::Writer).to have_received(:write).with("categories.json", "{}")
      end

      it "許可されたキーでネストされたカテゴリをダンプする" do
        described_class.run
        expect(Simpress::JSON).to have_received(:dump).with(anything, keys: described_class::KEYS)
      end
    end

    context "modeが不明な場合" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("unknown")
      end

      it "エラーを発生させる" do
        expect { described_class.run }.to raise_error("Unknown mode: unknown")
      end
    end

    context "category_indexes.jsonが存在する場合" do
      let(:rails_term) { Simpress::Taxonomy::Term.new("Rails", key: "rails") }
      let(:taxonomy) { instance_double(Simpress::Taxonomy, terms: { "ruby" => term, "rails" => rails_term }) }

      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
        allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
        allow(Simpress::JSON).to receive(:load_file).with("category_indexes.json").and_return({ "ruby" => ["rails"] })
      end

      it "子カテゴリを親の下にネストし、ルートから取り除く" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.any? {|c| c.key == "ruby" } && cats.none? {|c| c.key == "rails" } }
        )
      end
    end

    context "category_indexes.jsonにordersキーが含まれる場合" do
      let(:life_term) { Simpress::Taxonomy::Term.new("Life", key: "life") }
      let(:tech_term) { Simpress::Taxonomy::Term.new("Tech", key: "tech") }
      let(:taxonomy) { instance_double(Simpress::Taxonomy, terms: { "life" => life_term, "tech" => tech_term }) }

      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Theme).to receive(:render).and_return("")
        allow(Simpress::Context).to receive(:update)
        allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
        allow(Simpress::JSON).to receive(:load_file).with("category_indexes.json").and_return({ "orders" => ["tech", "life"] })
      end

      it "ordersリストに従ってルートカテゴリを並べ替える" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.map(&:key) == ["tech", "life"] }
        )
      end

      it "ordersキーを親子関係として扱わない" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.none? {|c| c.key == "orders" } }
        )
      end
    end

    context "category_indexes.jsonにネストとordersの両方がある場合" do
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

      it "ordersリストに従ってネストされた子を並べ替える" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy do |cats|
            ruby_category = cats.find {|c| c.key == "ruby" }
            ruby_category.children.map(&:key) == ["rails", "sinatra"]
          end
        )
      end

      it "ordersリストにないルートカテゴリを末尾に並べる" do
        described_class.run

        expect(Simpress::Theme).to have_received(:render).with(
          "sidebar_categories",
          categories: satisfy {|cats| cats.map(&:key) == ["ruby", "life"] }
        )
      end
    end
  end
end
