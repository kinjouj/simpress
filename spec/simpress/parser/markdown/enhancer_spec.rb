# frozen_string_literal: true

require "simpress/parser/markdown/enhancer"

describe Simpress::Parser::Markdown::Enhancer do
  after do
    described_class.clear
  end

  describe ".run" do
    it "executes preprocessors in order and updates data if a string is returned" do
      filter1 = Class.new do
        extend Simpress::Parser::Markdown::Enhancer

        def self.preprocess(data)
          "#{data} + Filter1"
        end
      end

      filter2 = Class.new do
        extend Simpress::Parser::Markdown::Enhancer

        def self.preprocess(data)
          "#{data} + Filter2"
        end
      end

      described_class.register_enhancers << filter1 << filter2

      result = described_class.run("Base")
      expect(result).to eq "Base + Filter1 + Filter2"
    end

    it "ignores non-string return values from preprocessors" do
      filter = Class.new do
        extend Simpress::Parser::Markdown::Enhancer

        def self.preprocess(_data)
          nil
        end
      end

      described_class.register_enhancers << filter
      result = described_class.run("Original")
      expect(result).to eq "Original"
    end
  end

  describe ".clear" do
    it "resets the registered classes" do
      filter = Class.new do
        extend Simpress::Parser::Markdown::Enhancer
      end

      described_class.register_enhancers << filter
      described_class.clear
      expect(described_class.register_enhancers).to be_empty
    end
  end

  describe "#preprocess" do
    it "raises NotImplementedError when called on an instance" do
      filter = Class.new do
        extend Simpress::Parser::Markdown::Enhancer
      end

      described_class.register_enhancers << filter
      expect { described_class.run("data") }.to raise_error(NotImplementedError)
    end
  end
end
