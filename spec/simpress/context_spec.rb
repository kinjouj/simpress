# frozen_string_literal: true

require "simpress/context"

describe Simpress::Context do
  after do
    described_class.clear
  end

  describe ".[]=" do
    it "値を設定する" do
      described_class[:test_key] = "value"
      expect(described_class[:test_key]).to eq "value"
    end
  end

  describe ".[]" do
    it "キーが存在しない場合はKeyErrorを発生させる" do
      expect { described_class[:missing] }.to raise_error(KeyError, "key not found: missing")
    end
  end

  describe ".update" do
    it "ハッシュのデータをコンテキストにマージする" do
      described_class.update(a: 1, b: 2)
      expect(described_class[:a]).to eq 1
      expect(described_class[:b]).to eq 2
    end
  end

  describe ".to_h" do
    it "データを含むハッシュを返す" do
      described_class[:key] = "val"
      expect(described_class.to_h).to eq({ key: "val" })
    end
  end

  describe ".clear" do
    it "全てのデータを削除する" do
      described_class[:key] = "val"
      described_class.clear
      expect { described_class[:key] }.to raise_error(KeyError)
    end
  end
end
