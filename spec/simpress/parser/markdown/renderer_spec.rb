# frozen_string_literal: true

require "simpress/parser/markdown/renderer"

describe Simpress::Parser::Markdown::Renderer do
  let(:renderer) do
    described_class.new
  end

  describe "#initialize" do
    it "sets default renderer options and calls reset!" do
      expect(renderer.primary_image).to be_nil
      expect(renderer.toc).to eq []
      expect(renderer.links).to eq []
    end
  end

  describe "#reset!" do
    it "clears primary_image, toc and links" do
      renderer.instance_variable_set(:@primary_image, "test.png")
      renderer.instance_variable_set(:@headings, [{ id: "id", text: "text", level: 2 }])
      renderer.instance_variable_set(:@links, ["/some/path.html"])
      renderer.reset!
      expect(renderer.primary_image).to be_nil
      expect(renderer.toc).to be_empty
      expect(renderer.links).to be_empty
    end
  end

  describe "#link" do
    it "collects internal links starting with /" do
      renderer.link("/2026/01/post.html", nil, "post")
      expect(renderer.links).to eq ["/2026/01/post.html"]
    end

    it "ignores external links" do
      renderer.link("https://example.com", nil, "example")
      expect(renderer.links).to be_empty
    end

    it "ignores nil url" do
      renderer.link(nil, nil, "empty")
      expect(renderer.links).to be_empty
    end

    it "returns an anchor tag" do
      result = renderer.link("/2026/01/post.html", nil, "post")
      expect(result).to eq '<a href="/2026/01/post.html" target="_blank" rel="noopener">post</a>'
    end
  end

  describe "#preprocess" do
    before do
      allow(Simpress::Parser::Markdown::Enhancer).to receive(:run).and_return("enhanced")
    end

    it "delegates to Simpress::Parser::Markdown::Enhancer.run" do
      markdown = "# Hello"
      result = renderer.preprocess(markdown)
      expect(Simpress::Parser::Markdown::Enhancer).to have_received(:run).with(markdown)
      expect(result).to eq "enhanced"
    end
  end

  describe "#header" do
    it "returns a simple h1 tag for level 1" do
      result = renderer.header("Title", 1)
      expect(result).to eq "<h1>Title</h1>"
      expect(renderer.toc).to be_empty
    end

    it "returns header with id and registers to toc for level 2 or higher" do
      result = renderer.header("SubTitle", 2)
      expect(result).to eq '<h2 id="section-1">SubTitle</h2>'
      expect(renderer.toc.size).to eq 1

      heading = renderer.toc.first
      expect(heading[:id]).to eq "section-1"
      expect(heading[:text]).to eq "SubTitle"
      expect(heading[:children]).to eq []
    end

    it "increments section ids" do
      renderer.header("First", 2)
      result = renderer.header("Second", 3)
      expect(result).to include('id="section-2"')
    end

    it "treats level 2 headers as top-level toc entries" do
      renderer.header("First", 2)
      renderer.header("Second", 2)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Second"]
    end

    it "nests a level 3+ header as a child of the preceding level 2 header" do
      renderer.header("First", 2)
      renderer.header("Second", 3)

      expect(renderer.toc.size).to eq 1
      first = renderer.toc.first
      expect(first[:text]).to eq "First"
      expect(first[:children].map {|heading| heading[:text] }).to eq ["Second"]
    end

    it "does not attach a children key to child-level nodes" do
      renderer.header("First", 2)
      renderer.header("Second", 3)

      child = renderer.toc.first[:children].first
      expect(child).to eq({ id: "section-2", text: "Second" })
    end

    it "flattens consecutive deeper headers into the same child list, regardless of level" do
      renderer.header("First", 2)
      renderer.header("Second", 3)
      renderer.header("Third", 4)

      expect(renderer.toc.first[:children].map {|heading| heading[:text] }).to eq ["Second", "Third"]
    end

    it "starts a new top-level section, resetting children, on the next level 2 header" do
      renderer.header("First", 2)
      renderer.header("Second", 3)
      renderer.header("Third", 2)
      renderer.header("Fourth", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Third"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Second"]
      expect(renderer.toc[1][:children].map {|heading| heading[:text] }).to eq ["Fourth"]
    end

    it "treats a deeper header as top-level if no level 2 header has appeared yet" do
      renderer.header("First", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First"]
    end

    it "establishes the top level dynamically from the first header when it is deeper than 2" do
      renderer.header("First", 3)
      renderer.header("Second", 4)
      renderer.header("Third", 4)
      renderer.header("Fourth", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Fourth"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Second", "Third"]
      expect(renderer.toc[1][:children]).to eq []
    end

    it "re-anchors nesting to a shallower header that appears after a deeper one" do
      renderer.header("A", 3)
      renderer.header("B", 2)
      renderer.header("C", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["A", "B"]
      expect(renderer.toc[0][:children]).to eq []
      expect(renderer.toc[1][:children].map {|heading| heading[:text] }).to eq ["C"]
    end
  end

  describe "#image" do
    it "returns an img tag and sets primary_image if it is the first one" do
      result = renderer.image("first.png", nil, nil)
      expect(result).to eq '<img src="first.png" alt="image" />'
      expect(renderer.primary_image).to eq "first.png"
    end

    it "does not overwrite primary_image with subsequent images" do
      renderer.image("first.png", nil, nil)
      renderer.image("second.png", nil, nil)
      expect(renderer.primary_image).to eq "first.png"
    end
  end

  describe "#block_code" do
    it "returns a pre/code block with escaped html" do
      code = 'puts "Hello" < & >'
      result = renderer.block_code(code, "ruby")
      expect(result).to include('class="language-ruby"')
      expect(result).to include("puts &quot;Hello&quot; &lt; &amp; &gt;")
    end

    it "defaults to text language if lang is nil" do
      result = renderer.block_code("code", nil)
      expect(result).to include('class="language-text"')
    end
  end
end
