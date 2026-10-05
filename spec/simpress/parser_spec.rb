# frozen_string_literal: true

require "simpress/parser"

describe Simpress::Parser do
  let(:file) { "2026-01-01-test-entry.md" }
  let(:markdown) do
    <<~MD
      ---
      title: Test Title
      permalink: /2026/01/test-entry
      ---
      This is the description.

      This is the content.
    MD
  end

  let(:render_result) do
    Simpress::Parser::Markdown::Processor::Result.new(
      content: "<p>This is the description.</p>\n<p>This is the content.</p>",
      toc: [],
      cover: "cover.jpg"
    )
  end

  before do
    allow(File).to receive(:read).with(file).and_return(markdown)
    allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(render_result)
    allow(XXhash).to receive(:xxh64).and_return(999)
  end

  describe ".parse" do
    it "エントリを返す" do
      entry = described_class.parse(file)
      entry.load!

      expect(entry.id).to eq "999"
      expect(entry.title).to eq "Test Title"
      expect(entry.date).to eq Time.new(2026, 1, 1)
      expect(entry.permalink).to eq "/2026/01/test-entry"
      expect(entry.content).to eq "<p>This is the description.</p>\n<p>This is the content.</p>"
      expect(entry.description).to eq "This is the description."
      expect(entry.cover).to eq "cover.jpg"
    end

    context "フロントマターにもファイル名にも日付を導出できない場合" do
      before do
        allow(File).to receive(:read).with("no-date.md").and_return("---\ntitle: No Date\npermalink: /no-date\n---\nbody")
      end

      it "現在時刻にフォールバックしindexを強制的にfalseにする" do
        entry = described_class.parse("no-date.md")

        expect(entry.date).to be_a(Time)
        expect(entry.date).to be_within(5).of(Time.now)
        expect(entry.index).to be_falsy
      end
    end

    context "フロントマターでpermalinkが指定されていない場合" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          ---
        MD
      end

      it "日付とbasenameからpermalinkを生成する" do
        expect(described_class.parse(file).permalink).to eq "/2026/01/2026-01-01-test-entry"
      end
    end

    context "フロントマターでpermalinkが指定されている場合" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          permalink: /existing/path
          ---
        MD
      end

      it "フロントマターのpermalinkをそのまま使用する" do
        expect(described_class.parse(file).permalink).to eq "/existing/path"
      end
    end

    context "フロントマターで日付が指定されている場合" do
      it "Time文字列、Date、String形式の日付を全てTimeにパースする" do
        time_string_md = <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-entry
          date: 2025-01-01 00:00:00 +0900
          ---
        MD
        allow(File).to receive(:read).with(file).and_return(time_string_md)
        expect(described_class.parse(file).date).to be_a(Time)

        date_md = <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-entry
          date: 2025-01-01
          ---
        MD
        allow(File).to receive(:read).with(file).and_return(date_md)
        expect(described_class.parse(file).date).to be_a(Time)

        string_md = <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-entry
          date: "2025-01-01"
          ---
        MD
        allow(File).to receive(:read).with(file).and_return(string_md)
        expect(described_class.parse(file).date).to be_a(Time)
      end
    end
  end
end
