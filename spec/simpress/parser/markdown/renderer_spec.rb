# frozen_string_literal: true

require "simpress/parser/markdown/renderer"

describe Simpress::Parser::Markdown::Renderer do
  let(:renderer) do
    described_class.new
  end

  describe "#initialize" do
    it "initializes empty" do
      expect(renderer.primary_image).to be_nil
      expect(renderer.toc).to eq []
    end
  end

  describe "#preprocess" do
    before do
      allow(Simpress::Parser::Markdown::Filter).to receive(:apply_preprocess).and_return("enhanced")
    end

    it "returns the preprocessed result" do
      markdown = "# Hello"
      result = renderer.preprocess(markdown)

      expect(Simpress::Parser::Markdown::Filter).to have_received(:apply_preprocess).with(markdown)
      expect(result).to eq "enhanced"
    end
  end

  describe "#postprocess" do
    before do
      allow(Simpress::Parser::Markdown::Filter).to receive(:apply_postprocess).and_return("processed")
    end

    it "returns the postprocessed result" do
      result = renderer.postprocess("<p>Hello</p>")

      expect(Simpress::Parser::Markdown::Filter).to have_received(:apply_postprocess).with("<p>Hello</p>")
      expect(result).to eq "processed"
    end
  end

  describe "#header" do
    it "returns h1 for level 1" do
      result = renderer.header("Title", 1)

      expect(result).to eq "<h1>Title</h1>"
      expect(renderer.toc).to be_empty
    end

    it "returns headings with ids" do
      result = renderer.header("SubTitle", 2)

      expect(result).to eq '<h2 id="section-1">SubTitle</h2>'
      expect(renderer.toc.size).to eq 1

      heading = renderer.toc.first
      expect(heading[:id]).to eq "section-1"
      expect(heading[:text]).to eq "SubTitle"
      expect(heading[:children]).to eq []
    end

    it "puts level 2 at top" do
      renderer.header("First", 2)
      renderer.header("Second", 2)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Second"]
    end

    it "nests level 3+ under 2" do
      renderer.header("First", 2)
      result = renderer.header("Second", 3)

      expect(result).to include('id="section-2"')
      expect(renderer.toc.size).to eq 1
      first = renderer.toc.first
      expect(first[:text]).to eq "First"
      expect(first[:children]).to eq [{ id: "section-2", text: "Second" }]
    end

    it "groups consecutive deep headings" do
      renderer.header("First", 2)
      renderer.header("Second", 3)
      renderer.header("Third", 4)

      expect(renderer.toc.first[:children].map {|heading| heading[:text] }).to eq ["Second", "Third"]
    end

    it "starts a new top entry" do
      renderer.header("First", 2)
      renderer.header("Second", 3)
      renderer.header("Third", 2)
      renderer.header("Fourth", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Third"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Second"]
      expect(renderer.toc[1][:children].map {|heading| heading[:text] }).to eq ["Fourth"]
    end

    it "makes early deep headings top-level" do
      renderer.header("First", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First"]
    end

    it "uses first heading as top" do
      renderer.header("First", 3)
      renderer.header("Second", 4)
      renderer.header("Third", 4)
      renderer.header("Fourth", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Fourth"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Second", "Third"]
      expect(renderer.toc[1][:children]).to eq []
    end

    it "makes shallower headings top-level" do
      renderer.header("A", 3)
      renderer.header("B", 2)
      renderer.header("C", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["A", "B"]
      expect(renderer.toc[0][:children]).to eq []
      expect(renderer.toc[1][:children].map {|heading| heading[:text] }).to eq ["C"]
    end
  end

  describe "#image" do
    it "returns an img tag" do
      result = renderer.image("first.png", nil, nil)

      expect(result).to eq '<img src="first.png" alt="" title="" />'
      expect(renderer.primary_image).to eq "first.png"
    end

    it "outputs alt and title" do
      result = renderer.image("first.png", "caption", "owl")

      expect(result).to eq '<img src="first.png" alt="owl" title="caption" />'
    end

    it "doesn't overwrite primary_image" do
      renderer.image("first.png", nil, nil)
      renderer.image("second.png", nil, nil)

      expect(renderer.primary_image).to eq "first.png"
    end
  end

  describe "#block_code" do
    it "returns an escaped code block" do
      result = renderer.block_code('puts "Hello" < & >', "ruby")

      expect(result).to include('class="language-ruby"')
      expect(result).to include("puts &quot;Hello&quot; &lt; &amp; &gt;")
    end

    context "when lang is nil" do
      it "falls back to text" do
        result = renderer.block_code("code", nil)

        expect(result).to include('class="language-text"')
      end
    end
  end
end
