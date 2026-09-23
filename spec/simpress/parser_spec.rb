# frozen_string_literal: true

require "simpress/parser"

describe Simpress::Parser do
  let(:file) { "2026-01-01-test-post.md" }
  let(:markdown) do
    <<~MD
      ---
      title: Test Title
      permalink: /2026/01/test-post
      ---
      This is the description.

      This is the content.
    MD
  end

  let(:render_result) do
    Simpress::Parser::Markdown::Processor::Result.new(
      content: "<p>This is the description.</p>\n<p>This is the content.</p>",
      toc: [],
      links: ["/2026/01/other-post.html"],
      cover: "cover.jpg"
    )
  end

  before do
    allow(File).to receive(:read).with(file).and_return(markdown)
    allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(render_result)
    allow(XXhash).to receive(:xxh64).and_return(999)
  end

  describe ".parse" do
    it "returns a post" do
      post = described_class.parse(file)
      post.load!

      expect(post.id).to eq "999"
      expect(post.title).to eq "Test Title"
      expect(post.date).to eq Time.new(2026, 1, 1)
      expect(post.permalink).to eq "/2026/01/test-post"
      expect(post.content).to eq "<p>This is the description.</p>\n<p>This is the content.</p>"
      expect(post.description).to eq "This is the description."
      expect(post.cover).to eq "cover.jpg"
      expect(post.links).to eq ["/2026/01/other-post.html"]
    end

    context "when date cannot be derived from front matter or file name" do
      before do
        allow(File).to receive(:read).with("no-date.md").and_return(
          "---\ntitle: No Date\npermalink: /no-date\n---\nbody"
        )
      end

      it "falls back to current time and forces index to false" do
        post = described_class.parse("no-date.md")

        expect(post.date).to be_a(Time)
        expect(post.date).to be_within(5).of(Time.now)
        expect(post.index).to be_falsy
      end
    end

    context "when permalink is not given in front matter" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          ---
        MD
      end

      it "generates permalink from date and basename" do
        expect(described_class.parse(file).permalink).to eq "/2026/01/2026-01-01-test-post"
      end
    end

    context "when permalink is given in front matter" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          permalink: /existing/path
          ---
        MD
      end

      it "uses the permalink from front matter as-is" do
        expect(described_class.parse(file).permalink).to eq "/existing/path"
      end
    end

    context "when date in front matter is given" do
      it "parses a Time string, a Date, and a String date, all into Time" do
        time_string_md = <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-post
          date: 2025-01-01 00:00:00 +0900
          ---
        MD
        allow(File).to receive(:read).with(file).and_return(time_string_md)
        expect(described_class.parse(file).date).to be_a(Time)

        date_md = <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-post
          date: 2025-01-01
          ---
        MD
        allow(File).to receive(:read).with(file).and_return(date_md)
        expect(described_class.parse(file).date).to be_a(Time)

        string_md = <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-post
          date: "2025-01-01"
          ---
        MD
        allow(File).to receive(:read).with(file).and_return(string_md)
        expect(described_class.parse(file).date).to be_a(Time)
      end
    end
  end
end
