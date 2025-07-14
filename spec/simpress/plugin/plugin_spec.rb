# frozen_string_literal: true

require "simpress/config"
require "simpress/plugin"
require "simpress/plugin/preprocessor"

describe Simpress::Plugin do
  context "#load" do
    it "test_plugin.rbがロードされること" do
      allow(Dir).to receive(:[]).and_return([ create_filepath("test_plugin.rb") ])
      expect(Simpress::Plugin::Preprocessor).to receive(:extended).once
      Simpress::Plugin.load
      expect(Object.const_get("Simpress::Plugin::Preprocessor::TestPlugin")).not_to be_nil
    end
  end
end
