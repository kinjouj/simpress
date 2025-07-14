# frozen_string_literal: true

require "simpress/context"

describe Simpress::Context do
  after do
    Simpress::Context.clear
  end

  describe "[] and []=" do
    context "値をつっこんだり取得してみたりした場合" do
      it "successful" do
        Simpress::Context.instance[:key] = "hoge"
        expect(Simpress::Context[:key]).to eq("hoge")
      end

      it "存在しないキーを指定した場合、例外が発生すること" do
        expect { Simpress::Context[:key] }.to raise_error("key missing")
      end
    end
  end

  describe "#update" do
    it "successful" do
      Simpress::Context.update(key: "test", version: 1)
      expect(Simpress::Context[:key]).to eq("test")
      expect(Simpress::Context[:version]).to eq(1)
    end

    context "引数がHashじゃない場合" do
      it "例外が発生すること" do
        expect { Simpress::Context.update([]) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#clear" do
    context "値をつっこんだあとでclearを呼んだ場合" do
      it "ちゃんと値が消えていること" do
        Simpress::Context.instance[:key] = "hoge"
        expect(Simpress::Context[:key]).to eq("hoge")
        Simpress::Context.clear
        expect(Simpress::Context.instance.keys).to eq([])
        expect { Simpress::Context[:key] }.to raise_error("key missing")
      end
    end
  end
end
