# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/theme"
require "simpress/plugin/preprocessor"
require "simpress/plugin/preprocessor/html_loader"

describe Simpress::Plugin::Preprocessor::HtmlLoader do
  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
  end

  after do
    Simpress::Context.clear
  end

  context "run" do
    it "successful" do
      allow(Dir).to receive(:[]).and_return([fixture("preprocessor/html_loader/test.html").path])
      described_class.run
      expect(Simpress::Context[:html_test]).to eq("test\n")
    end

    it "ファイル名がtest.txt.htmlの場合" do
      allow(Dir).to receive(:[]).and_return([fixture("preprocessor/html_loader/test.txt.html").path])
      described_class.run
      expect(Simpress::Context[:html_testtxt]).to eq("TEXT\n")
    end

    it "ファイル名がtest-file.htmlの場合" do
      allow(Dir).to receive(:[]).and_return([fixture("preprocessor/html_loader/test-file.html").path])
      described_class.run
      expect(Simpress::Context[:html_testfile]).to eq("test file\n")
    end

    it "MODEがhtmlじゃない場合" do
      allow(Simpress::Config.instance).to receive(:mode).and_return(:json)
      described_class.run
      expect { Simpress::Context[:html_test] }.to raise_error("html_test missing")
    end
  end
end
