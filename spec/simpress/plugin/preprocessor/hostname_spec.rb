# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "simpress/plugin"
require "simpress/plugin/preprocessor"
require "simpress/plugin/preprocessor/hostname"

describe Simpress::Plugin::Preprocessor::Hostname do
  before do
    stub_const("Simpress::Config::CONFIG_FILE", fixture("test_config.yaml").path)
    Simpress::Config.clear
  end

  after do
    Simpress::Context.clear
  end

  context "run" do
    it "successful" do
      Simpress::Plugin::Preprocessor::Hostname.run
      expect(Simpress::Context[:hostname]).to eq("http://localhost")
    end

    it "modeがhtmlじゃない場合" do
      allow(Simpress::Config.instance).to receive(:mode).and_return(:json)
      Simpress::Plugin::Preprocessor::Hostname.run
      expect { Simpress::Context[:hostname] }.to raise_error("hostname missing")
    end
  end
end
