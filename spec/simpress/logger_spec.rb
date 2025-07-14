# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"

describe Simpress::Logger do
  before do
    Singleton.__init__(Simpress::Logger)
    allow(Simpress::Config.instance).to receive(:logging).and_return(true)
    allow(Simpress::Config.instance).to receive(:debug).and_return(true)
  end

  describe "#info" do
    it "infoのテスト" do
      expect { Simpress::Logger.info("test") }.to output(/INFO -- : test\n$/).to_stdout
    end

    context "configでloggingがfalseの場合" do
      it "ログが出力されないこと" do
        allow(Simpress::Config.instance).to receive(:logging).and_return(false)
        expect { Simpress::Logger.info("test") }.not_to output.to_stdout
      end
    end
  end

  describe "#warn" do
    it "warnのテスト" do
      expect { Simpress::Logger.warn("test") }.to output(/WARN -- : test\n$/).to_stdout
    end
  end

  describe "#debug" do
    it "debugのテスト" do
      expect { Simpress::Logger.debug("test") }.to output.to_stdout
    end

    context "configでdebugがfalseの場合" do
      it "ログが出力されないこと" do
        allow(Simpress::Config.instance).to receive(:debug).and_return(false)
        expect { Simpress::Logger.debug("test") }.not_to output.to_stdout
      end
    end
  end
end
