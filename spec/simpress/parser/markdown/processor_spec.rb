# frozen_string_literal: true

require "simpress/parser/markdown/processor"

describe Simpress::Parser::Markdown::Processor do
  let(:markdown1) do
    <<~MD
      ## Hello

      ![alt](cover.png)

      some content

      ### Sub

      more content
    MD
  end

  let(:markdown2) do
    <<~MD
      ## World

      some content
    MD
  end

  describe ".render" do
    it "returns content, toc and cover" do
      result = described_class.render(markdown1)

      expect(result.content).to include("Hello")
      expect(result.cover).to eq "cover.png"
      expect(result.toc.size).to eq 1
      expect(result.toc.first[:id]).to eq "section-1"
      expect(result.toc.first[:text]).to eq "Hello"
      expect(result.toc.first[:children]).to eq [{ id: "section-2", text: "Sub" }]
    end

    it "doesn't keep previous state" do
      described_class.render(markdown1)
      result = described_class.render(markdown2)

      expect(result.content).to include("World")
      expect(result.cover).to be_nil
      expect(result.toc.size).to eq 1
      expect(result.toc.first[:id]).to eq "section-1"
      expect(result.toc.first[:text]).to eq "World"
    end
  end
end
