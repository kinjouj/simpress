# frozen_string_literal: true

require "simpress/parser/markdown"

describe Simpress::Parser::Markdown do
  describe ".parse" do
    it "successfully parses header with Time and returns the body" do
      txt = <<~MARKDOWN
        ---
        title: Hello World
        date: 2026-01-01 10:00:00 +0900
        ---
        # Content
      MARKDOWN

      header, body = described_class.parse(txt)
      expect(header[:title]).to eq "Hello World"
      expect(header[:date]).to be_a(Time)
      expect(body).to eq "# Content\n"
    end

    it "raises an error when the markdown does not have front matter" do
      txt = "No front matter here"
      expect { described_class.parse(txt) }.to raise_error("Markdown parse failed")
    end
  end
end
