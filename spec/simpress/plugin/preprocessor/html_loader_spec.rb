# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/theme"
require "simpress/plugin/preprocessor"
require "simpress/plugin/preprocessor/html_loader"

describe Simpress::Plugin::Preprocessor::HtmlLoader do
  after do
    Simpress::Context.clear
  end

  context "run" do
    it "successful" do
      allow(Dir).to receive(:[]).and_return([ File.expand_path("test.html", __dir__) ])
      Simpress::Plugin::Preprocessor::HtmlLoader.run
      expect(Simpress::Context[:html_test]).to start_with("test")
    end

    it "MODEがhtmlじゃない場合" do
      allow(Simpress::Config.instance).to receive(:mode).and_return(:json)
      Simpress::Plugin::Preprocessor::HtmlLoader.run
      expect { Simpress::Context[:html_test] }.to raise_error("html_test missing")
    end
  end
end
