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
    it "delegates to Simpress::JSON.encode" do
      data = { key: "value" }
      expect(helper.encode_json(data)).to eq '{"key":"value"}'
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

  describe "#flatten_toc" do
    it "returns an empty array for an empty toc" do
      expect(helper.flatten_toc([])).to eq []
    end

    it "assigns depth 0 to a flat list of headings" do
      headings = [{ id: "section-1", text: "First", children: [] }]
      result   = helper.flatten_toc(headings)
      expect(result).to eq [{ id: "section-1", text: "First", depth: 0 }]
    end

    it "keeps sibling headings in order at the same depth" do
      headings = [
        { id: "section-1", text: "First", children: [] },
        { id: "section-2", text: "Second", children: [] }
      ]
      result = helper.flatten_toc(headings)
      expect(result).to eq [
        { id: "section-1", text: "First", depth: 0 },
        { id: "section-2", text: "Second", depth: 0 }
      ]
    end

    it "places a child directly after its parent with an incremented depth" do
      child  = { id: "section-2", text: "Child" }
      parent = { id: "section-1", text: "Parent", children: [child] }
      result = helper.flatten_toc([parent])
      expect(result).to eq [
        { id: "section-1", text: "Parent", depth: 0 },
        { id: "section-2", text: "Child", depth: 1 }
      ]
    end
  end
end
