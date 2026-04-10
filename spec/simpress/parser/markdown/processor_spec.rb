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
    it "returns rendered html body, primary_image, and toc" do
      body, image, toc = described_class.render(markdown1)
      expect(body).to include("Hello")
      expect(image).to eq "cover.png"
      expect(toc).to eq([["section-1", "Hello"]])
    end

    it "does not carry over state from a previous render" do
      described_class.render(markdown1)
      body, image, toc = described_class.render(markdown2)
      expect(body).to include("World")
      expect(image).to be_nil
      expect(toc).to eq([["section-1", "World"]])
    end
  end
end
