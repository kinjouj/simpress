# frozen_string_literal: true

require "simpress/category"

describe Simpress::Category do
  context "新しいカテゴリーを作成する場合" do
    it "カテゴリーが正しく初期化されること" do
      category = described_class.new("Ruby")
      expect(category).not_to be_nil
      expect(category.key).to eq("ruby")
      expect(category.name).to eq("Ruby")
      expect(category.count).to eq(1)
    end
  end

  describe "#eql?" do
    it "同じ名前のカテゴリー同士は等しいと判定されること" do
      category1 = described_class.new("Ruby")
      category2 = described_class.new("Ruby")
      expect(category1).to eql(category2)
    end
  end

  describe "#as_json" do
    it "正しいハッシュ形式でJSONに変換されること" do
      category = described_class.new("Ruby")
      expect(category.as_json).to include(key: "ruby", name: "Ruby", count: 1, children: {})
    end
  end

  describe "#to_json" do
    it "正しいJSON文字列として出力されること" do
      category = described_class.new("Ruby")
      expect(category.to_json).to eq({ key: "ruby", name: "Ruby", count: 1, children: {} }.to_json)
    end
  end

  context "Hash or Setのキーにオブジェクトを指定した場合" do
    let(:category1) { described_class.new("test") }
    let(:category2) { described_class.new("test") }

    it "Hashに同じカテゴリーを追加しても1つしか入らないこと" do
      hash = {}
      hash[category1] = 1
      expect(hash).to include(category2)
      hash[category2] = 2
      expect(hash.size).to eq(1)
    end

    it "Setに同じカテゴリー追加しても1しか入らないこと" do
      set = Set.new
      set << category1
      set << category2
      expect(set.size).to eq(1)
    end
  end

  context "引数がnilな場合" do
    it "例外が発生すること" do
      expect { described_class.new(nil) }.to raise_error("category is empty")
      expect { described_class.new("") }.to  raise_error("category is empty")
    end
  end
end
