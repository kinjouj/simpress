# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/plugin"
require "simpress/logger"

describe Simpress::Plugin do
  after do
    described_class.clear
  end

  it "#load" do
    stub_const("Simpress::Plugin::PLUGIN_DIR", fixture("./plugins").path)
    described_class.load
    expect(described_class.register_plugins).not_to be_empty
  end

  it "test1" do
    allow(Simpress::Logger).to receive(:debug)
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
    allow(Simpress::Config.instance).to receive(:plugins).and_return(%w[test1_plugin])

    test1_class = Class.new do
      extend Simpress::Plugin

      def self.run(*_args)
        bind_context(mode: config.mode)
      end
    end

    hoge_class = Class.new do
      extend Simpress::Plugin

      def self.run(*_args)
        bind_context(msg: "hoge")
      end
    end

    stub_const("Simpress::Plugin::Test1Plugin", test1_class)
    stub_const("Simpress::Plugin::HogePlugin", hoge_class)
    described_class.process
    expect(Simpress::Context[:mode]).to eq(:html)
    expect { Simpress::Context[:msg] }.to raise_error("'msg' missing")
    expect(Simpress::Logger).to have_received(:debug).once
  end

  it "test2" do
    test2_plugin = Class.new do
      extend Simpress::Plugin
    end

    allow(Simpress::Logger).to receive(:debug)
    allow(Simpress::Config.instance).to receive(:plugins).and_return(["test2_plugin"])
    stub_const("Simpress::Plugin::Test2Plugin", test2_plugin)
    expect { described_class.process }.to raise_error(RuntimeError)
    expect(Simpress::Logger).to have_received(:debug).once
  end
end
