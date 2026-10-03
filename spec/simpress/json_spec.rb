# frozen_string_literal: true

require "simpress/json"

describe Simpress::JSON do
  describe ".load_file" do
    before do
      allow(Oj).to receive(:load_file)
    end

    it "オプション付きでOj.load_fileに委譲する" do
      described_class.load_file("test.json", symbolize_names: true)
      expect(Oj).to have_received(:load_file).with("test.json", symbolize_names: true)
    end
  end

  describe ".load" do
    before do
      allow(Oj).to receive(:load)
    end

    it "オプション付きでOj.loadに委譲する" do
      described_class.load('{"a":1}', mode: :strict)
      expect(Oj).to have_received(:load).with('{"a":1}', mode: :strict)
    end
  end

  describe ".dump" do
    before do
      allow(Oj).to receive(:dump)
    end

    it "オプション付きでOj.dumpに委譲する" do
      described_class.dump({ a: 1 }, indent: 2)
      expect(Oj).to have_received(:dump).with({ a: 1 }, indent: 2)
    end
  end

  describe ".encode" do
    before do
      allow(Oj).to receive(:dump)
    end

    it "railsモードとxss_safeエスケープモードでOj.dumpを呼び出す" do
      described_class.encode({ html: "<script>" })
      expect(Oj).to have_received(:dump).with({ html: "<script>" }, mode: :rails, escape_mode: :xss_safe)
    end
  end
end
