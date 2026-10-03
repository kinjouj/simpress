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

  describe "#encode_json" do
    it "Simpress::JSON.encodeに委譲する" do
      data = { key: "value" }
      expect(helper.encode_json(data)).to eq '{"key":"value"}'
    end
  end

  describe "#canonical" do
    before do
      allow(Simpress::Config.instance).to receive(:host).and_return("https://example.com/")
    end

    it "ホスト名とhtml拡張子を持つ絶対URLを返す" do
      expect(helper.canonical("/entry-1")).to eq "https://example.com/entry-1.html"
    end
  end

  describe "#uri" do
    it "パスをラップしてhtml拡張子を保証する" do
      expect(helper.uri("/test").to_s).to eq "/test.html"
    end
  end

  describe "#flatten_toc" do
    it "空のtocに対しては空配列を返す" do
      expect(helper.flatten_toc([])).to eq []
    end

    it "フラットな見出しリストにはdepth 0を割り当てる" do
      headings = [{ id: "section-1", text: "First", children: [] }]
      result = helper.flatten_toc(headings)
      expect(result).to eq [{ id: "section-1", text: "First", depth: 0 }]
    end

    it "兄弟の見出しを同じdepthで順序を保ったまま保持する" do
      headings = [{ id: "section-1", text: "First", children: [] }, { id: "section-2", text: "Second", children: [] }]
      result = helper.flatten_toc(headings)
      expect(result).to eq [{ id: "section-1", text: "First", depth: 0 }, { id: "section-2", text: "Second", depth: 0 }]
    end

    it "子を親の直後にdepthをインクリメントして配置する" do
      child = { id: "section-2", text: "Child" }
      parent = { id: "section-1", text: "Parent", children: [child] }
      result = helper.flatten_toc([parent])
      expect(result).to eq [{ id: "section-1", text: "Parent", depth: 0 }, { id: "section-2", text: "Child", depth: 1 }]
    end
  end
end
