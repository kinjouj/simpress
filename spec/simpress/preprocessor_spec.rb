# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/preprocessor"
require "simpress/logger"

describe Simpress::Preprocessor do
  after do
    described_class.finish
  end

  it "test1" do
    allow(Simpress::Logger).to receive(:debug)
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
    allow(Simpress::Config.instance).to receive(:preprocessors).and_return(%w[test1_preprocessor])

    test1_class = Class.new do
      extend Simpress::Preprocessor

      def self.run(*_args)
        bind_context(mode: config.mode)
      end
    end

    hoge_class = Class.new do
      extend Simpress::Preprocessor

      def self.run(*_args)
        bind_context(msg: "hoge")
      end
    end

    stub_const("Simpress::Preprocessor::Test1Preprocessor", test1_class)
    stub_const("Simpress::Preprocessor::HogePreprocessor", hoge_class)

    described_class.process(nil, nil, nil)
    expect(Simpress::Context[:mode]).to eq(:html)
    expect { Simpress::Context[:msg] }.to raise_error("'msg' missing")
    expect(Simpress::Logger).to have_received(:debug).exactly(1)
  end

  it "test2" do
    test2_plugin = Class.new do
      extend Simpress::Preprocessor
    end

    allow(Simpress::Logger).to receive(:debug)
    allow(Simpress::Config.instance).to receive(:preprocessors).and_return(["test2_plugin"])
    stub_const("Simpress::Preprocessor::Test2Plugin", test2_plugin)
    expect { described_class.process(nil, nil, nil) }.to raise_error(RuntimeError)
    expect(Simpress::Logger).to have_received(:debug).once
  end
end
