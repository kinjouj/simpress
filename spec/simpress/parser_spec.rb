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

      expect(entry.id).to eq "999"
      expect(entry.title).to eq "Test Title"
      expect(entry.date).to eq Time.new(2026, 1, 1)
      expect(entry.permalink).to eq "/2026/01/test-entry"
      expect(entry.content).to eq "<p>This is the description.</p>\n<p>This is the content.</p>"
      expect(entry.toc).to eq []
      expect(entry.description).to eq "This is the description."
      expect(entry.cover).to eq "cover.jpg"
      expect(Simpress::Parser::Markdown::Processor).to have_received(:render).with("This is the description.\n\nThis is the content.\n")
    end

    context "フロントマターでcoverとdescriptionが指定されている場合" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-entry
          cover: front.png
          description: Front description
          ---
          body
        MD
      end

      it "本文から抽出したcoverとdescriptionよりフロントマターの値を優先する" do
        entry = described_class.parse(file)

        expect(entry.cover).to eq "front.png"
        expect(entry.description).to eq "Front description"
      end
    end

    context "フロントマターでcoverとdescriptionが指定されておらず、本文から画像も抽出されなかった場合" do
      let(:render_result) do
        Simpress::Parser::Markdown::Processor::Result.new(content: "<p>Hello <strong>world</strong>!</p>", toc: [], cover: nil)
      end

      it "coverはデフォルト、descriptionは最初の段落のテキスト(インラインタグ除去)にフォールバックする" do
        entry = described_class.parse(file)

        expect(entry.cover).to eq described_class::DEFAULT_COVER
        expect(entry.description).to eq "This is the description."
      end
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

    context "フロントマターにカテゴリが指定されている場合" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-entry
          categories: Ruby
          ---
          body
        MD
      end

      before do
        allow(Simpress::Config.instance).to receive(:taxonomies).and_return({ "categories" => { "Ruby" => "ruby" } })
        allow(File).to receive(:read).with("2026-01-02-hidden.md").and_return("---\ntitle: Hidden\nindex: false\ncategories: Ruby\n---\nbody")
        allow(File).to receive(:read).with("no-date.md").and_return("---\ntitle: No Date\npermalink: /no-date\ncategories: Ruby\n---\nbody")
      end

      after do
        Simpress::Taxonomy.clear
      end

      it "indexがtrueならtaxonomiesのtermを持ち、falseまたは日付なしで強制falseならtaxonomiesを持たない" do
        listed = described_class.parse(file)
        hidden = described_class.parse("2026-01-02-hidden.md")
        undated = described_class.parse("no-date.md")

        expect(listed.taxonomies["categories"].map(&:name)).to eq ["Ruby"]
        expect(listed.taxonomies["categories"].first.entries).not_to include(listed)
        expect(listed.params[:categories]).to eq "Ruby"
        expect(hidden.taxonomies.values).to all(eq [])
        expect(undated.taxonomies.values).to all(eq [])
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
