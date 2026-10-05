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
    it "content、toc、coverを持つResultを返す" do
      result = described_class.render(markdown1)
      expect(result.content).to include("Hello")
      expect(result.cover).to eq "cover.png"
      expect(result.toc.size).to eq 1
      expect(result.toc.first[:id]).to eq "section-1"
      expect(result.toc.first[:text]).to eq "Hello"
    end

    it "前回のレンダリングの状態を引き継がない" do
      described_class.render(markdown1)
      result = described_class.render(markdown2)
      expect(result.content).to include("World")
      expect(result.cover).to be_nil
      expect(result.toc.size).to eq 1
      expect(result.toc.first[:id]).to eq "section-1"
      expect(result.toc.first[:text]).to eq "World"
    end

    it "Redcarpetでパースした実際のMarkdown見出しからネストされたtocを構築する" do
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

      result = described_class.render(markdown)

      expect(result.toc.map {|heading| heading[:text] }).to eq ["Introduction", "Conclusion"]
      expect(result.toc[0][:children].map {|heading| heading[:text] }).to eq ["Background", "Motivation"]
      expect(result.toc[1][:children]).to eq []
      expect(result.toc[0][:id]).to eq "section-1"
      expect(result.toc[0][:children][0][:id]).to eq "section-2"
      expect(result.toc[0][:children][1][:id]).to eq "section-3"
      expect(result.toc[1][:id]).to eq "section-4"
    end

    it "実際のh1はtocに含めない通常の見出しとして扱う" do
      markdown = <<~MD
        # Title

        ## Section

        content
      MD

      result = described_class.render(markdown)
      expect(result.content).to include("<h1>Title</h1>")
      expect(result.toc.map {|heading| heading[:text] }).to eq ["Section"]
    end
  end
end
