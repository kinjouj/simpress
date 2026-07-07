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

  describe "#render_toc" do
    it "returns an empty array for an empty toc" do
      expect(helper.render_toc([])).to eq []
    end

    it "assigns depth 0 to a flat list of headings" do
      headings = [{ id: "section-1", text: "First", children: [] }]
      result   = helper.render_toc(headings)
      expect(result).to eq [{ id: "section-1", text: "First", depth: 0 }]
    end

    it "keeps sibling headings in order at the same depth" do
      headings = [
        { id: "section-1", text: "First", children: [] },
        { id: "section-2", text: "Second", children: [] }
      ]
      result = helper.render_toc(headings)
      expect(result).to eq [
        { id: "section-1", text: "First", depth: 0 },
        { id: "section-2", text: "Second", depth: 0 }
      ]
    end

    it "places a child directly after its parent with an incremented depth" do
      child  = { id: "section-2", text: "Child" }
      parent = { id: "section-1", text: "Parent", children: [child] }
      result = helper.render_toc([parent])
      expect(result).to eq [
        { id: "section-1", text: "Parent", depth: 0 },
        { id: "section-2", text: "Child", depth: 1 }
      ]
    end
  end
end
