# frozen_string_literal: true

require "simpress/plugin/category_tree"

describe Simpress::Plugin::CategoryTree do
  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return("html")
    allow(Simpress::Theme).to receive(:render).and_return("test data")
    allow(File).to receive(:exist?).with("category_indexes.json").and_return(false)
    Simpress::Context.instance.clear
    Simpress::Taxonomy.clear

    categories = Simpress::Taxonomy.fetch("categories")
    categories.term("Root")
    categories.term("Child1")
    categories.term("Child2")
  end

  context "modeがhtmlの場合" do
    it "Themeが正しい引数で呼ばれ、結果がContextにセットされること" do
      described_class.run(nil, nil)
      expect(Simpress::Theme).to have_received(:render).with("sidebar_categories", categories: anything)
      expect(Simpress::Context[:sidebar_categories_content]).to eq("test data")
    end
  end

  context "modeがjsonの場合" do
    before do
      allow(Simpress::Config.instance).to receive(:mode).and_return("json")
      allow(Simpress::Writer).to receive(:write)
    end

    it "categories.jsonが書き出され、Contextへのセットは行われないこと" do
      described_class.run(nil, nil)
      expect(Simpress::Writer).to have_received(:write).with("categories.json", anything)
      expect { Simpress::Context[:sidebar_categories_content] }.to raise_error(KeyError)
    end
  end

  context "modeが未知の値の場合" do
    before do
      allow(Simpress::Config.instance).to receive(:mode).and_return("unknown")
    end

    it "例外が発生すること" do
      expect { described_class.run(nil, nil) }.to raise_error(RuntimeError)
    end
  end

  context "category_indexes.jsonが存在する場合" do
    before do
      allow(Simpress::Config.instance).to receive(:mode).and_return("json")
      allow(Simpress::Writer).to receive(:write)
      allow(File).to receive(:exist?).with("category_indexes.json").and_return(true)
    end

    context "rootとchildが両方categoriesに存在する場合" do
      before do
        allow(Simpress::JSON).to receive(:load_file).and_return({ "root" => ["child1", "child2"] })
      end

      it "childrenがrootに移動され、トップレベルから削除されること" do
        described_class.run(nil, nil)
        expect(Simpress::Writer).to have_received(:write).with("categories.json", anything) do |_, data|
          json = Simpress::JSON.load(data)
          expect(json["root"]["children"].size).to eq(2)
          expect(json).not_to have_key("child1")
          expect(json).not_to have_key("child2")
        end
      end
    end

    context "category_indexes.jsonのrootキーがcategoriesに存在しない場合" do
      before do
        allow(Simpress::JSON).to receive(:load_file).and_return({ "nonexistent" => ["child1"] })
      end

      it "エラーにならずcategoriesの構造が変わらないこと" do
        expect { described_class.run(nil, nil) }.not_to raise_error
        expect(Simpress::Writer).to have_received(:write).with("categories.json", anything) do |_, data|
          json = Simpress::JSON.load(data)
          expect(json.keys).to contain_exactly("root", "child1", "child2")
        end
      end
    end

    context "category_indexes.jsonのchildキーがcategoriesに存在しない場合" do
      before do
        allow(Simpress::JSON).to receive(:load_file).and_return({ "root" => ["nonexistent"] })
      end

      it "エラーにならずrootのchildrenが空のままであること" do
        expect { described_class.run(nil, nil) }.not_to raise_error
        expect(Simpress::Writer).to have_received(:write).with("categories.json", anything) do |_, data|
          json = Simpress::JSON.load(data)
          expect(json["root"]["children"]).to be_empty
        end
      end
    end
  end
end
