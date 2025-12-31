# frozen_string_literal: true

require "simpress/markdown/filter"

describe Simpress::Markdown::Filter do
  before do
    allow(Simpress::Logger).to receive(:debug)
  end

  after do
    described_class.clear
  end

  context "Filterプラグインのテスト" do
    it "Simpress::Parser::Redcarpet::Filterを継承したクラスが正常にプラグインとして作動すること" do
      test_filter = Class.new do
        extend Simpress::Markdown::Filter

        def self.preprocess(body)
          body.capitalize
        end
      end

      stub_const("TestFilter", test_filter)
      expect(described_class.run("test")).to eq("Test")
      expect(Simpress::Logger).to have_received(:debug).exactly(1).times
    end

    it "preprocessメソッドが定義されてない場合" do
      test_filter = Class.new do
        extend Simpress::Markdown::Filter
      end

      stub_const("TestFilter", test_filter)
      expect { described_class.run("dummy") }.to raise_error(RuntimeError)
      expect(Simpress::Logger).to have_received(:debug).exactly(1).times
    end

    it "preprocessメソッドの返り値がStringではない場合" do
      test_filter = Class.new do
        extend Simpress::Markdown::Filter

        def self.preprocess(_)
          {}
        end
      end

      stub_const("TestFilter", test_filter)
      expect(described_class.run("test")).to eq("test")
      expect(Simpress::Logger).to have_received(:debug).exactly(1).times
    end
  end
end
