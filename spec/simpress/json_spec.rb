# frozen_string_literal: true

require "simpress/json"

describe Simpress::JSON do
  describe ".load_file" do
    before do
      allow(Oj).to receive(:load_file)
    end

    it "delegates to Oj.load_file with options" do
      described_class.load_file("test.json", symbolize_names: true)
      expect(Oj).to have_received(:load_file).with("test.json", symbolize_names: true)
    end
  end

  describe ".load" do
    before do
      allow(Oj).to receive(:load)
    end

    it "delegates to Oj.load with options" do
      described_class.load('{"a":1}', mode: :strict)
      expect(Oj).to have_received(:load).with('{"a":1}', mode: :strict)
    end
  end

  describe ".dump" do
    before do
      allow(Oj).to receive(:dump)
    end

    it "delegates to Oj.dump with options" do
      described_class.dump({ a: 1 }, indent: 2)
      expect(Oj).to have_received(:dump).with({ a: 1 }, indent: 2)
    end
  end

  describe ".encode" do
    before do
      allow(Oj).to receive(:dump)
    end

    it "calls Oj.dump with rails mode and xss_safe escape mode" do
      described_class.encode({ html: "<script>" })
      expect(Oj).to have_received(:dump).with({ html: "<script>" }, mode: :rails, escape_mode: :xss_safe)
    end
  end
end
