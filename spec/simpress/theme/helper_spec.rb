# frozen_string_literal: true

require "simpress/theme/helper"

describe Simpress::Theme::Helper do
  let(:helper_test_class) do
    Class.new do
      include Simpress::Theme::Helper
    end
  end

  let(:helper) do
    helper_test_class.new
  end

  describe "#json_encode" do
    it "delegates to Simpress::JSON.encode" do
      data = { key: "value" }
      expect(helper.json_encode(data)).to eq '{"key":"value"}'
    end
  end

  describe "#canonical" do
    before do
      allow(Simpress::Config.instance).to receive(:host).and_return("https://example.com/")
    end

    it "returns an absolute URL with the hostname and html extension" do
      expect(helper.canonical("/post-1")).to eq "https://example.com/post-1.html"
    end
  end

  describe "#uri" do
    it "wraps the path and ensures html extension" do
      expect(helper.uri("/test").to_s).to eq "/test.html"
    end
  end

  describe "#link_to" do
    it "generates a simple anchor tag" do
      expect(helper.link_to("Home", "/")).to eq '<a href="/">Home</a>'
    end

    it "includes additional attributes in the anchor tag" do
      result = helper.link_to("About", "/about", class: "nav-link", target: "_blank")
      expect(result).to include('class="nav-link"')
      expect(result).to include('target="_blank"')
    end
  end
end
