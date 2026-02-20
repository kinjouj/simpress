# frozen_string_literal: true

require "simpress/plugin"

describe Simpress::Plugin do
  before do
    described_class.clear
  end

  describe ".load" do
    before do
      allow(Simpress::Logger).to receive(:debug)
      allow(Simpress::Config.instance).to receive(:plugins).and_return(["sample"])
      allow(described_class).to receive(:plugin_dir).and_return(File.expand_path("plugins", __dir__))
    end

    it "plugin_dirとpluginsの設定に基づいてプラグインが正しくロードされること" do
      described_class.load
      described_class.process
      expect(described_class.register_plugins).not_to be_empty
      expect(Simpress::Logger).to have_received(:debug).once
    end
  end

  describe ".process" do
    context "pluginsを指定して実行対象をフィルタした場合" do
      before do
        allow(Simpress::Logger).to receive(:debug)
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(Simpress::Config.instance).to receive(:plugins).and_return(["test1_plugin"])
      end

      it "指定したプラグインのみが実行されること" do
        test1_class = Class.new do
          extend Simpress::Plugin

          def self.run(*_args)
            bind_context(mode: config.mode.to_sym)
          end
        end

        hoge_class = Class.new do
          extend Simpress::Plugin

          def self.run(*_args)
            raise "ERROR!"
          end
        end

        stub_const("Simpress::Plugin::Test1Plugin", test1_class)
        stub_const("Simpress::Plugin::HogePlugin", hoge_class)
        expect(described_class.register_plugins).not_to be_empty
        described_class.process
        expect(Simpress::Context[:mode]).to eq(:html)
        expect { Simpress::Context[:msg] }.to raise_error(KeyError)
        expect(Simpress::Logger).to have_received(:debug).once
      end
    end

    context "runメソッドが実装されていないプラグインがある場合" do
      before do
        allow(Simpress::Logger).to receive(:debug)
        allow(Simpress::Config.instance).to receive(:plugins).and_return(["test2_plugin"])
      end

      it "NotImplementedError が発生すること" do
        test2_plugin = Class.new do
          extend Simpress::Plugin
        end

        stub_const("Simpress::Plugin::Test2Plugin", test2_plugin)
        expect { described_class.process }.to raise_error(NotImplementedError)
        expect(Simpress::Logger).to have_received(:debug).once
      end
    end
  end
end
