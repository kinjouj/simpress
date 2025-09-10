# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"

describe Simpress::Logger do
  before do
    described_class.clear
    allow(Simpress::Config.instance).to receive(:logging).and_return(true)
  end

  describe "#info" do
    it "infoのテスト" do
      expect { described_class.info("test") }.to output.to_stdout
    end

    context "configでloggingがfalseの場合" do
      it "ログが出力されないこと" do
        allow(Simpress::Config.instance).to receive(:logging).and_return(false)
        expect { described_class.info("test") }.not_to output.to_stdout
      end
    end
  end

  describe "#debug" do
    it "debugのテスト" do
      expect { described_class.debug("test") }.to output.to_stdout
    end
  end
end
