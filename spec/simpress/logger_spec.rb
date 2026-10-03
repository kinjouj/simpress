# frozen_string_literal: true

require "simpress/logger"

describe Simpress::Logger do
  before do
    described_class.clear
  end

  describe ".info" do
    context "ログ出力が有効な場合" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(true)
      end

      it "メッセージを標準出力に出力する" do
        expect { described_class.verbose("test info message") }.to output(/INFO -- : test info message/).to_stdout
      end
    end

    context "ログ出力が無効な場合" do
      before do
        allow(Simpress::Config.instance).to receive(:logging).and_return(false)
      end

      it "メッセージを出力しない" do
        expect { described_class.verbose("test info message") }.not_to output.to_stdout
      end
    end
  end

  describe ".debug" do
    it "デバッグメッセージを標準出力に出力する" do
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
    it "シングルトンインスタンスをリセットする" do
      obj = described_class.instance
      described_class.clear
      expect(obj).not_to be described_class.instance
    end
  end
end
