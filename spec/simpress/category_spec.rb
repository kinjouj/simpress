# frozen_string_literal: true

require "simpress/category"

describe Simpress::Category do
  before do
    described_class.clear
  end

  context "新しいカテゴリーを作成する場合" do
    it "カテゴリーが正しく初期化されること" do
      category = described_class.fetch("Ruby")
      expect(category.key).to eq("ruby")
      expect(category.name).to eq("Ruby")
      expect(category.count).to eq(1)
    end
  end

  describe "#initialize_copy" do

    it "正しくchildrenまでコピーできて、コピー側から追加して元のオブジェクトには作用しないこと" do
      category = described_class.fetch("Ruby")
      category.children["rspec"] = described_class.fetch("rspec")

      cloned = category.dup
      cloned.children["rails"] = described_class.fetch("Rails")

      expect(category.children).not_to eq(cloned.children)
      expect(category.children).not_to have_key("rails")
    end
  end

  describe "#increment!" do
    it "正しくcountが+1されること" do
      category = described_class.fetch("Ruby")
      expect(category.count).to eq(1)
      category.increment!
      expect(category.count).to eq(2)
    end
  end

  describe "#as_json" do
    it "正しいハッシュ形式に変換されること" do
      category = described_class.fetch("Ruby")
      expect(category.as_json).to include(key: "ruby", name: "Ruby")
    end

    it "keysで指定したキーだけ取得できること" do
      category = described_class.fetch("Ruby")
      category.children[:rails] = described_class.fetch("Rails")
      expect(
        category.as_json(keys: [:key, :children])
      ).to eq(
        {
          key: "ruby",
          children: {
            rails: { key: "rails", children: {} }
          }
        }
      )
    end
  end

  describe "#to_json" do
    it "JSONデータが取得できること" do
      category = described_class.fetch("Ruby")
      expect(category.to_json).not_to be_empty
    end
  end
end
