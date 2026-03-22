# frozen_string_literal: true

require "simpress/theme/helper"

describe Simpress::Theme::Helper do
  let(:helper) do
    Class.new { include Simpress::Theme::Helper }.new
  end

  describe "#json_encode" do
    let(:data) { { key: "value", num: 42 } }

    it "Simpress::JSON.encodeに委譲する" do
      expect(helper.json_encode(data)).to eq('{"key":"value","num":42}')
    end
  end

  describe "#canonical" do
    before do
      allow(Simpress::Config.instance).to receive(:host).and_return("https://example.com/")
    end

    it "host + path を返す" do
      expect(helper.canonical("/about")).to eq("https://example.com/about")
    end
  end

  describe "#link_to" do
    it "属性を正しく組み立てた <a> タグを生成する" do
      result = helper.link_to("外部", "https://example.com", target: "_blank", rel: "noopener")
      expect(result).to eq('<a href="https://example.com" target="_blank" rel="noopener">外部</a>')
    end
  end
end
