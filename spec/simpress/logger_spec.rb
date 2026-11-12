# frozen_string_literal: true

require "simpress/logger"

describe Simpress::Logger do
  after do
    described_class.clear
  end

  describe ".verbose" do
    context "when logging is enabled" do
      before do
        allow(Simpress::Config).to receive(:logging).and_return(true)
      end

      context "when given a message" do
        it "prints the log" do
          expect { described_class.verbose("test info message") }.to output(/INFO -- : test info message/).to_stdout
        end
      end

      context "when given a block" do
        it "prints the log" do
          expect { described_class.verbose { "test info block" } }.to output(/INFO -- : test info block/).to_stdout
        end
      end
    end

    context "when logging is disabled" do
      before do
        allow(Simpress::Config).to receive(:logging).and_return(false)
      end

      it "prints nothing" do
        expect { described_class.verbose { true } }.not_to output.to_stdout
      end
    end
  end

  describe ".debug" do
    it "prints the log" do
      expect { described_class.debug("test debug message") }.to output(/DEBUG -- : test debug message/).to_stdout
    end
  end

  describe ".clear" do
    it "resets the settings" do
      obj = described_class.instance
      described_class.clear

      expect(obj).not_to be described_class.instance
    end
  end
end
