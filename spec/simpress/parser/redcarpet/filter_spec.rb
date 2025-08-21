# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"
require "simpress/parser/redcarpet/filter"

describe Simpress::Parser::Redcarpet::Filter do
  after do
    described_class.clear
  end

  context "Filterプラグインのテスト" do
    it "Simpress::Parser::Redcarpet::Filterを継承したクラスが正常にプラグインとして作動すること" do
      test_filter = Class.new do
        extend Simpress::Parser::Redcarpet::Filter

        def self.preprocess(body)
          body.capitalize
        end
      end

      stub_const("TestFilter", test_filter)
      expect(described_class.run("test")).to eq("Test")
    end

    it "preprocessメソッドが定義されてない場合" do
      test_filter = Class.new do
        extend Simpress::Parser::Redcarpet::Filter
      end

      stub_const("TestFilter", test_filter)
      expect { described_class.run("dummy") }.to raise_error(RuntimeError)
    end

    it "preprocessメソッドの返り値がStringではない場合" do
      test_filter = Class.new do
        extend Simpress::Parser::Redcarpet::Filter

        def self.preprocess(_)
          {}
        end
      end

      stub_const("TestFilter", test_filter)
      expect(described_class.run("test")).to eq("test")
    end
  end
end
