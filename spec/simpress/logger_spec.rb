# frozen_string_literal: true

require "simpress/logger"

describe Simpress::Logger do
  after do
    described_class.clear
  end

  describe ".info" do
    context "when logging is enabled" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(true)
      end

      it "logs the message to stdout" do
        expect { described_class.info("test info message") }.to output(/INFO -- : test info message/).to_stdout
      end
    end

    context "when logging is disabled" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(false)
      end

      it "does not log the message" do
        expect { described_class.info("test info message") }.not_to output.to_stdout
      end
    end
  end

  describe ".debug" do
    it "logs the debug message to stdout" do
      expect { described_class.debug("test debug message") }.to output(/DEBUG -- : test debug message/).to_stdout
    end
  end

  describe ".logging?" do
    context "when logging is enabled" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(true)
      end

      it "returns true" do
        expect(described_class.logging?).to be true
      end
    end

    context "when logging is disabled" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(false)
      end

      it "returns false" do
        expect(described_class.logging?).to be false
      end
    end
  end

  describe ".clear" do
    it "resets the singleton instance" do
      obj = described_class.instance
      described_class.clear
      expect(obj).not_to be described_class.instance
    end
  end
end
