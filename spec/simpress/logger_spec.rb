# frozen_string_literal: true

require "simpress/logger"

describe Simpress::Logger do
  before do
    described_class.clear
  end

  describe ".verbose" do
    context "ログ出力が有効な場合" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(true)
      end

      it "標準出力に出力されること" do
        expect { described_class.verbose("test info message") }.to output(/INFO -- : test info message/).to_stdout

        described_class.clear
        expect { described_class.verbose { "test info block" } }.to output(/INFO -- : test info block/).to_stdout
      end
    end

    context "ログ出力が無効な場合" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(false)
      end

      it "標準出力に出力されないこと" do
        evaluated = false

        expect { described_class.verbose { evaluated = true } }.not_to output.to_stdout
        expect(evaluated).to be false
      end
    end
  end

  describe ".debug" do
    it "標準出力に出力されること" do
      expect { described_class.debug("test debug message") }.to output(/DEBUG -- : test debug message/).to_stdout
    end
  end

  describe ".logging?" do
    context "ログ出力が有効な場合" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(true)
      end

      it "trueを返す" do
        expect(described_class.logging?).to be true
      end
    end

    context "ログ出力が無効な場合" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(false)
      end

      it "falseを返す" do
        expect(described_class.logging?).to be false
      end
    end
  end

  describe ".clear" do
    it "設定をリセットする" do
      obj = described_class.instance
      described_class.clear
      expect(obj).not_to be described_class.instance
    end
  end
end
