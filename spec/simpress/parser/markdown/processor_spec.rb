# frozen_string_literal: true

require "simpress/parser/markdown/processor"

describe Simpress::Parser::Markdown::Processor do
  let(:markdown1) do
    <<~MD
      ## Hello

      ![alt](cover.png)

      some content
    MD
  end

  let(:markdown2) do
    <<~MD
      ## World

      some content
    MD
  end

  before do
    described_class.instance_variable_set(:@parser, nil)
  end

  describe ".render" do
    it "returns rendered html body and renderer" do
      body, renderer = described_class.render(markdown1)
      expect(body).to include("Hello")
      expect(renderer.primary_image).to eq "cover.png"
      expect(renderer.toc.size).to eq 1
      expect(renderer.toc.first[:id]).to eq "section-1"
      expect(renderer.toc.first[:text]).to eq "Hello"
      expect(renderer.links).to eq []
    end

    it "does not carry over state from a previous render" do
      described_class.render(markdown1)
      body, renderer = described_class.render(markdown2)
      expect(body).to include("World")
      expect(renderer.primary_image).to be_nil
      expect(renderer.toc.size).to eq 1
      expect(renderer.toc.first[:id]).to eq "section-1"
      expect(renderer.toc.first[:text]).to eq "World"
      expect(renderer.links).to eq []
    end

    it "builds a nested toc from real markdown headings parsed through Redcarpet" do
      markdown = <<~MD
        ## Introduction

        some content

        ### Background

        more content

        ### Motivation

        more content

        ## Conclusion

        final content
      MD

      _body, renderer = described_class.render(markdown)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["Introduction", "Conclusion"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Background", "Motivation"]
      expect(renderer.toc[1][:children]).to eq []
      expect(renderer.toc[0][:id]).to eq "section-1"
      expect(renderer.toc[0][:children][0][:id]).to eq "section-2"
      expect(renderer.toc[0][:children][1][:id]).to eq "section-3"
      expect(renderer.toc[1][:id]).to eq "section-4"
    end

    it "treats a real h1 as a plain heading excluded from the toc" do
      markdown = <<~MD
        # Title

        ## Section

        content
      MD

      body, renderer = described_class.render(markdown)

      expect(body).to include("<h1>Title</h1>")
      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["Section"]
    end
  end
end
