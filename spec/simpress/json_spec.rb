# frozen_string_literal: true

require "simpress/json"

describe Simpress::JSON do
  describe "Ojデフォルト設定" do
    it "必要なオプションが設定されている" do
      expect(Oj.default_options).to include(mode: :custom, use_to_json: true, use_as_json: true, time_format: :xmlschema)
    end
  end

  describe ".load" do
    it "JSON文字列をパースする" do
      expect(described_class.load('{"k":1}')).to eq({ "k" => 1 })
      expect(described_class.load("[1,2]")).to eq([1, 2])
    end

    it "オプションを渡せる" do
      expect(described_class.load('{"k":1}', symbol_keys: true)).to eq({ k: 1 })
    end

    it "不正なJSONで例外を発生させる" do
      expect { described_class.load("bad") }.to raise_error(Oj::ParseError)
    end
  end

  describe ".load_file" do
    it "ファイルをパースする" do
      allow(Oj).to receive(:load_file).with("test.json").and_return({ "k" => 1 })
      expect(described_class.load_file("test.json")).to eq({ "k" => 1 })
    end
  end

  describe ".dump" do
    it "RubyオブジェクトをJSON文字列に変換する" do
      expect(Oj.load(described_class.dump({ "k" => 1 }))).to eq({ "k" => 1 })
      expect(described_class.dump([1, 2])).to eq("[1,2]")
      expect(described_class.dump(nil)).to eq("null")
    end
  end

  describe ".encode" do
    it "RubyオブジェクトをXSS安全なJSON文字列に変換する" do
      expect(Oj.load(described_class.encode({ "k" => "v" }))).to eq({ "k" => "v" })
      expect(described_class.encode({ "h" => "<script>" })).not_to include("<script>")
      expect(described_class.encode({ "h" => "a & b" })).not_to include("&")
    end
  end
end
