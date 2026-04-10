# frozen_string_literal: true

require "simpress/parser"

describe Simpress::Parser do
  let(:file) { "2026-01-01-test-post.md" }
  let(:markdown) do
    <<~MD
      ---
      title: Test Title
      ---
      This is the description.

      This is the content.
    MD
  end

  let(:render_result) { ["<p>content</p>", "cover.jpg", "<ul>toc</ul>"] }

  before do
    allow(File).to receive(:read).with(file).and_return(markdown)
    allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(render_result)
    allow(XXhash).to receive(:xxh64).and_return(999)
  end

  describe ".parse" do
    it "returns a post" do
      post = described_class.parse(file)
      expect(post.id).to eq "999"
      expect(post.title).to eq "Test Title"
      expect(post.date).to eq Time.new(2026, 1, 1)
      expect(post.permalink).to eq "/2026/01/2026-01-01-test-post"
      expect(post.content).to eq "<p>content</p>"
      expect(post.description).to eq "This is the description."
      expect(post.cover).to eq "cover.jpg"
    end

    it "raises ParseError when date information is missing" do
      allow(File).to receive(:read).with("no-date.md").and_return("---\ntitle: No Date\n---\nbody")
      expect { described_class.parse("no-date.md") }.to raise_error(Simpress::Parser::ParseError)
    end

    context "when date in front matter is parsed as Time" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          date: 2025-01-01 00:00:00 +0900
          ---
          This is the description.

          This is the content.
        MD
      end

      it "converts Date to Time" do
        expect(described_class.parse(file).date).to be_a(Time)
      end
    end

    context "when date in front matter is parsed as Date" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          date: 2025-01-01
          ---
          This is the description.

          This is the content.
        MD
      end

      it "converts Date to Time" do
        expect(described_class.parse(file).date).to be_a(Time)
      end
    end

    context "when date in front matter is parsed as String" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          date: "2025-01-01"
          ---
          This is the description.

          This is the content.
        MD
      end

      it "converts Date to Time" do
        expect(described_class.parse(file).date).to be_a(Time)
      end
    end

    context "when permalink is given in front matter" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          permalink: /existing/path
          ---
          This is the description.

          This is the content.
        MD
      end

      it "uses the permalink from front matter as-is" do
        expect(described_class.parse(file).permalink).to eq "/existing/path"
      end
    end
  end
end
