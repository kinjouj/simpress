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
    end
  end

  describe "#reset!" do
    it "clears primary_image and toc" do
      renderer.instance_variable_set(:@primary_image, "test.png")
      renderer.instance_variable_set(:@toc, [["id", "text"]])
      renderer.reset!
      expect(renderer.primary_image).to be_nil
      expect(renderer.toc).to be_empty
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
      expect(renderer.toc).to eq [["section-1", "SubTitle"]]
    end

    it "increments section ids" do
      renderer.header("First", 2)
      result = renderer.header("Second", 3)
      expect(result).to include('id="section-2"')
      expect(renderer.toc.size).to eq 2
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
