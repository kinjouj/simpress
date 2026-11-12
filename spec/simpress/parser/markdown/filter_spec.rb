# frozen_string_literal: true

require "simpress/parser/markdown/filter"

describe Simpress::Parser::Markdown::Filter do
  after do
    described_class.clear
  end

  describe ".apply_preprocess" do
    it "applies filters in order" do
      filter1 = Class.new do
        extend Simpress::Parser::Markdown::Filter

        def self.preprocess(data)
          "#{data} + Filter1"
        end
      end

      filter2 = Class.new do
        extend Simpress::Parser::Markdown::Filter

        def self.preprocess(data)
          "#{data} + Filter2"
        end
      end

      described_class.register_filters << filter1 << filter2

      expect(described_class.apply_preprocess("Base")).to eq "Base + Filter1 + Filter2"
    end

    it "ignores non-string values" do
      filter = Class.new do
        extend Simpress::Parser::Markdown::Filter

        def self.preprocess(_data)
          {}
        end
      end

      described_class.register_filters << filter

      expect(described_class.apply_preprocess("Original")).to eq "Original"
    end
  end

  describe ".apply_postprocess" do
    it "applies filters in order" do
      filter1 = Class.new do
        extend Simpress::Parser::Markdown::Filter

        def self.postprocess(data)
          "#{data} + Filter1"
        end
      end

      filter2 = Class.new do
        extend Simpress::Parser::Markdown::Filter

        def self.postprocess(_data)
          nil
        end
      end

      described_class.register_filters << filter1 << filter2

      expect(described_class.apply_postprocess("Base")).to eq "Base + Filter1"
    end
  end

  describe ".clear" do
    it "clears the registered filters" do
      filter = Class.new do
        extend Simpress::Parser::Markdown::Filter
      end

      described_class.register_filters << filter
      described_class.clear

      expect(described_class.register_filters).to be_empty
    end
  end
end
