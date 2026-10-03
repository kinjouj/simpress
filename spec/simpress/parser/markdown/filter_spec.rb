# frozen_string_literal: true

require "simpress/parser/markdown/filter"

describe Simpress::Parser::Markdown::Filter do
  after do
    described_class.clear
  end

  describe ".preprocess" do
    it "preprocessを順番に実行し、文字列が返された場合はデータを更新する" do
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

      result = described_class.preprocess("Base")
      expect(result).to eq "Base + Filter1 + Filter2"
    end

    it "preprocessが返した文字列以外の値は無視する" do
      filter = Class.new do
        extend Simpress::Parser::Markdown::Filter

        def self.preprocess(_data)
          {}
        end
      end

      described_class.register_filters << filter
      result = described_class.preprocess("Original")
      expect(result).to eq "Original"
    end
  end

  describe ".postprocess" do
    it "postprocessを順番に実行し、文字列以外の返り値は無視する" do
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
      expect(described_class.postprocess("Base")).to eq "Base + Filter1"
    end
  end

  describe ".clear" do
    it "登録されたクラスをリセットする" do
      filter = Class.new do
        extend Simpress::Parser::Markdown::Filter
      end

      described_class.register_filters << filter
      described_class.clear
      expect(described_class.register_filters).to be_empty
    end
  end
end
