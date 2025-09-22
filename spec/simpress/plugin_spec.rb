# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/plugin"
require "simpress/logger"

describe Simpress::Plugin do
  after do
    described_class.clear
  end

  describe "#load" do
    it "plugin_dirを指定したロードした場合に正しくプラグインがロードされているか" do
      allow(Simpress::Logger).to receive(:debug)
      allow(Simpress::Config.instance).to receive(:plugin_dir).and_return(fixture("plugins").path)
      allow(Simpress::Config.instance).to receive(:plugins).and_return(["sample"])
      described_class.load
      described_class.process
      expect(described_class.register_plugins).not_to be_empty
      expect(Simpress::Logger).to have_received(:debug).once
    end
  end

  describe "#process" do
    context "pluginsを指定してフィルターした場合" do
      it "test1_plugin以外が実行されないこと" do
        test1_class = Class.new do
          extend Simpress::Plugin

          def self.run(*_args)
            bind_context(mode: :html)
          end
        end

        hoge_class = Class.new do
          extend Simpress::Plugin

          def self.run(*_args)
            raise "ERROR!"
          end
        end

        allow(Simpress::Logger).to receive(:debug)
        allow(Simpress::Config.instance).to receive(:plugins).and_return(["test1_plugin"])
        stub_const("Simpress::Plugin::Test1Plugin", test1_class)
        stub_const("Simpress::Plugin::HogePlugin", hoge_class)
        expect(described_class.register_plugins).not_to be_empty
        described_class.process
        expect(Simpress::Context[:mode]).to eq(:html)
        expect { Simpress::Context[:msg] }.to raise_error("'msg' missing")
        expect(Simpress::Logger).to have_received(:debug).once
      end
    end

    context "processメソッドが実装されてない場合" do
      it "エラーが起きること" do
        test2_plugin = Class.new do
          extend Simpress::Plugin
        end

        allow(Simpress::Logger).to receive(:debug)
        allow(Simpress::Config.instance).to receive(:plugins).and_return(["test2_plugin"])
        stub_const("Simpress::Plugin::Test2Plugin", test2_plugin)
        expect { described_class.process }.to raise_error(NotImplementedError)
        expect(Simpress::Logger).to have_received(:debug).once
      end
    end
  end
end
