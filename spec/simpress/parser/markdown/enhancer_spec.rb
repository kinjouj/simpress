# frozen_string_literal: true

require "simpress/parser/markdown/enhancer"

describe Simpress::Parser::Markdown::Enhancer do
  before do
    allow(Simpress::Logger).to receive(:debug)
  end

  after do
    described_class.clear
  end

  describe ".extended" do
    it "registers the class and logs a debug message" do
      filter_class = Class.new do
        extend Simpress::Parser::Markdown::Enhancer
      end

      expect(described_class.classes).to include(filter_class)
      expect(Simpress::Logger).to have_received(:debug).with("REGISTER FILTER: #{filter_class}")
    end
  end

  describe ".run" do
    it "executes preprocessors in order and updates data if a string is returned" do
      Class.new do
        extend Simpress::Parser::Markdown::Enhancer

        def self.preprocess(data)
          "#{data} + Filter1"
        end
      end

      Class.new do
        extend Simpress::Parser::Markdown::Enhancer

        def self.preprocess(data)
          "#{data} + Filter2"
        end
      end

      result = described_class.run("Base")
      expect(result).to eq "Base + Filter1 + Filter2"
    end

    it "ignores non-string return values from preprocessors" do
      Class.new do
        extend Simpress::Parser::Markdown::Enhancer

        def self.preprocess(_data)
          nil
        end
      end

      result = described_class.run("Original")
      expect(result).to eq "Original"
    end
  end

  describe ".clear" do
    it "resets the registered classes" do
      Class.new do
        extend Simpress::Parser::Markdown::Enhancer
      end

      described_class.clear
      expect(described_class.classes).to be_empty
    end
  end

  describe "#preprocess" do
    it "raises NotImplementedError when called on an instance" do
      Class.new do
        extend Simpress::Parser::Markdown::Enhancer
      end

      expect { described_class.run("data") }.to raise_error(NotImplementedError)
    end
  end
end
