# frozen_string_literal: true

require "simpress/logger"

describe Simpress::Logger do
  after do
    described_class.clear
  end

  describe ".verbose" do
    context "ログ出力が有効な場合" do
      before do
        allow(Simpress::Config).to receive(:logging).and_return(true)
      end

      context "メッセージを渡した場合" do
        it "出力されること" do
          expect { described_class.verbose("test info message") }.to output(/INFO -- : test info message/).to_stdout
        end
      end

      context "ブロックを渡した場合" do
        it "出力されること" do
          expect { described_class.verbose { "test info block" } }.to output(/INFO -- : test info block/).to_stdout
        end
      end
    end

    context "ログ出力が無効な場合" do
      before do
        allow(Simpress::Config).to receive(:logging).and_return(false)
      end

      it "出力されないこと" do
        expect { described_class.verbose { true } }.not_to output.to_stdout
      end
    end
  end

  describe ".debug" do
    it "出力されること" do
      expect { described_class.debug("test debug message") }.to output(/DEBUG -- : test debug message/).to_stdout
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
