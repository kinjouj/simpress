# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"
require "simpress/parser/redcarpet/filter"

describe Simpress::Parser::Redcarpet::Filter do
  after do
    Object.send(:remove_const, :TestFilter) if defined?(TestFilter)
    Simpress::Parser::Redcarpet::Filter.clear
  end

  context "Filterプラグインのテスト" do
    it "Simpress::Parser::Redcarpet::Filterを継承したクラスが正常にプラグインとして作動すること" do
      expect(Simpress::Logger).to receive(:debug).once

      class TestFilter
        extend Simpress::Parser::Redcarpet::Filter

        def self.preprocess(body)
          body.capitalize
        end
      end

      expect(Simpress::Parser::Redcarpet::Filter.run("test")).to eq("Test")
    end

    it "preprocessメソッドが定義されてない場合" do
      expect(Simpress::Logger).to receive(:debug).once

      class TestFilter
        extend Simpress::Parser::Redcarpet::Filter
      end

      expect { Simpress::Parser::Redcarpet::Filter.run("dummy") }.to raise_error(RuntimeError)
    end

    it "preprocessメソッドの返り値がStringではない場合" do
      expect(Simpress::Logger).to receive(:debug).once

      class TestFilter
        extend Simpress::Parser::Redcarpet::Filter

        def self.preprocess(_)
          {}
        end
      end

      expect(Simpress::Parser::Redcarpet::Filter.run("test")).to eq("test")
    end
  end
end
