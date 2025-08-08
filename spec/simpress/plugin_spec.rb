# frozen_string_literal: true

require "simpress/config"
require "simpress/plugin"
require "simpress/plugin/preprocessor"

describe Simpress::Plugin do
  describe "#load" do
    it "test_plugin.rbがロードされること" do
      allow(Simpress::Plugin::Preprocessor).to receive(:extended)
      allow(Dir).to receive(:[]).and_return([create_filepath("plugin/test_plugin.rb")])
      described_class.load
      expect(Object.const_get("Simpress::Plugin::Preprocessor::TestPlugin")).not_to be_nil
      expect(Simpress::Plugin::Preprocessor).to have_received(:extended).once
    end
  end
end
