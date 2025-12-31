# frozen_string_literal: true

require "simpress/context"

describe Simpress::Context do
  after do
    described_class.clear
  end

  describe "[] and []=" do
    context "値をつっこんだり取得してみたりした場合" do
      it "successful" do
        described_class[:key] = "hoge"
        expect(described_class[:key]).to eq("hoge")
      end

      it "存在しないキーを指定した場合、例外が発生すること" do
        expect { described_class[:key] }.to raise_error(KeyError)
      end
    end
  end

  describe ".update" do
    it "successful" do
      described_class.update(key: "test", version: 1)
      expect(described_class[:key]).to eq("test")
      expect(described_class[:version]).to eq(1)
    end
  end

  describe ".clear" do
    context "値をつっこんだあとでclearを呼んだ場合" do
      it "ちゃんと値が消えていること" do
        described_class[:key] = "hoge"
        expect(described_class[:key]).to eq("hoge")
        described_class.clear
        expect { described_class[:key] }.to raise_error(KeyError)
      end
    end
  end
end
