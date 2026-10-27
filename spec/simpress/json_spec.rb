# frozen_string_literal: true

require "simpress/json"

describe Simpress::JSON do
  describe ".load_file" do
    before do
      allow(Oj).to receive(:load_file)
    end

    it "ファイルを読み込む" do
      described_class.load_file("test.json", symbolize_names: true)
      expect(Oj).to have_received(:load_file).with("test.json", symbolize_names: true)
    end
  end

  describe ".load" do
    before do
      allow(Oj).to receive(:load)
    end

    it "文字列を読み込む" do
      described_class.load('{"a":1}', mode: :strict)
      expect(Oj).to have_received(:load).with('{"a":1}', mode: :strict)
    end
  end

  describe ".dump" do
    before do
      allow(Oj).to receive(:dump)
    end

    it "JSON文字列にする" do
      described_class.dump({ a: 1 }, indent: 2)
      expect(Oj).to have_received(:dump).with({ a: 1 }, indent: 2)
    end
  end

  describe ".encode" do
    before do
      allow(Oj).to receive(:dump)
    end

    it "エスケープしたJSON文字列にする" do
      described_class.encode({ html: "<script>" })
      expect(Oj).to have_received(:dump).with({ html: "<script>" }, mode: :rails, escape_mode: :xss_safe)
    end
  end

  describe "Timeの出力" do
    it "書かれたタイムゾーンの年月日と時刻とutc_offsetのオブジェクトにする" do
      time = Time.new(2026, 2, 1, 5, 0, 0, "+09:00")

      expect(time.as_json).to eq({ year: 2026, month: 2, day: 1, hour: 5, minute: 0, second: 0, utc_offset: 32_400 })
      expect(described_class.dump({ date: time })).to eq '{"date":{"year":2026,"month":2,"day":1,"hour":5,"minute":0,"second":0,"utc_offset":32400}}'
    end
  end
end
