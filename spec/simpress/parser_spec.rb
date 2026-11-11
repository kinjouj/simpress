# frozen_string_literal: true

require "simpress/parser"

describe Simpress::Parser do
  let(:file) do
    "2026-01-01-test-entry.md"
  end

  let(:markdown) do
    <<~MD
      ---
      title: Test Title
      date: 2026-01-01
      permalink: /2026/01/test-entry
      ---
      This is the description.

      This is the content.
    MD
  end

  let(:body) do
    <<~MD
      This is the description.

      This is the content.
    MD
  end

  let(:html) do
    <<~HTML
      <p>This is the description.</p>
      <p>This is the content.</p>
    HTML
  end

  before do
    allow(File).to receive(:read).and_return(markdown)
    allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(Simpress::Parser::Markdown::Processor::Result.new(html, "cover.jpg", []))
    allow(XXhash).to receive(:xxh64).and_return(999)
  end

  describe ".parse" do
    it "エントリを返す" do
      entry = described_class.parse(file)

      expect(entry.id).to eq "999"
      expect(entry.title).to eq "Test Title"
      expect(entry.date).to eq Time.new(2026, 1, 1)
      expect(entry.permalink).to eq "/2026/01/test-entry"
      expect(entry.content).to eq html
      expect(entry.toc).to eq []
      expect(entry.description).to eq "This is the description."
      expect(entry.cover).to eq "cover.jpg"
      expect(Simpress::Parser::Markdown::Processor).to have_received(:render).with(body)
    end

    context "フロントマターに独自キーが指定されている場合" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-entry
          og_image: /images/og.png
          ---
          body
        MD
      end

      it "paramsから独自キーを参照できる" do
        entry = described_class.parse(file)

        expect(entry.params[:og_image]).to eq "/images/og.png"
        expect(entry.params[:title]).to eq "Test Title"
      end
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
      before do
        allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(
          Simpress::Parser::Markdown::Processor::Result.new("<p>Hello <strong>world</strong>!</p>", nil, [])
        )
      end

      it "coverはデフォルト、descriptionは最初の段落のテキスト(インラインタグ除去)にフォールバックする" do
        entry = described_class.parse(file)

        expect(entry.cover).to eq described_class::DEFAULT_COVER
        expect(entry.description).to eq "This is the description."
      end
    end

    context "フロントマターでdraftが指定されている場合" do
      let(:markdown) do
        <<~MD
          ---
          title: Draft Title
          date: 2026-01-01
          draft: true
          ---
          body
        MD
      end

      it "Markdownをレンダリングしない" do
        entry = described_class.parse(file)

        expect(entry.draft).to be true
        expect(entry.content).to be_nil
        expect(Simpress::Parser::Markdown::Processor).not_to have_received(:render)
      end
    end

    context "フロントマターにdateが指定されていない場合" do
      context "ファイル名に日付がない場合" do
        let(:markdown) do
          <<~MD
            ---
            title: No Date
            permalink: /no-date
            ---
            body
          MD
        end

        it "dateをnilにしてindexをfalseにする" do
          entry = described_class.parse("no-date.md")

          expect(entry.date).to be_nil
          expect(entry.index).to be false
        end
      end

      context "ファイル名に日付がある場合" do
        let(:markdown) do
          <<~MD
            ---
            title: From Filename
            ---
            body
          MD
        end

        it "dateをnilにしてindexをfalseにする" do
          entry = described_class.parse("2026-01-01-from-filename.md")

          expect(entry.date).to be_nil
          expect(entry.index).to be false
        end
      end
    end

    context "フロントマターにカテゴリが指定されている場合" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          date: 2026-01-01
          permalink: /2026/01/test-entry
          categories: Ruby
          ---
          body
        MD
      end

      before do
        allow(Simpress::Config).to receive(:taxonomies).and_return({ aliases: { categories: { Ruby: "ruby" } } })
      end

      after do
        Simpress::Taxonomy.clear
      end

      it "taxonomiesのtermを持つ" do
        entry = described_class.parse(file)

        expect(entry.taxonomies["categories"].map(&:name)).to eq ["Ruby"]
        expect(entry.taxonomies["categories"].first.entries).not_to include(entry)
      end

      context "indexがfalseの場合" do
        let(:markdown) do
          <<~MD
            ---
            title: Hidden
            date: 2026-01-02
            index: false
            categories: Ruby
            ---
            body
          MD
        end

        it "taxonomiesを持たない" do
          entry = described_class.parse(file)

          expect(entry.taxonomies.values).to all(eq [])
        end
      end

      context "dateが指定されていない場合" do
        let(:markdown) do
          <<~MD
            ---
            title: No Date
            permalink: /no-date
            categories: Ruby
            ---
            body
          MD
        end

        it "taxonomiesを持たない" do
          entry = described_class.parse(file)

          expect(entry.taxonomies.values).to all(eq [])
        end
      end
    end

    context "フロントマターでpermalinkが指定されていない場合" do
      context "サブディレクトリのファイルの場合" do
        let(:markdown) do
          <<~MD
            ---
            title: About
            date: 2026-01-01
            ---
            body
          MD
        end

        it "ディレクトリとbasenameからpermalinkを生成する" do
          expect(described_class.parse("source/company/about.markdown").permalink).to eq "/company/about"
        end
      end

      context "sourceの直下のファイルの場合" do
        let(:markdown) do
          <<~MD
            ---
            title: Contact
            ---
            body
          MD
        end

        it "basenameからpermalinkを生成する" do
          expect(described_class.parse("source/contact.markdown").permalink).to eq "/contact"
        end
      end
    end

    context "フロントマターでpermalinkが指定されている場合" do
      context "sourceの直下のファイルの場合" do
        let(:markdown) do
          <<~MD
            ---
            title: Test Title
            permalink: /existing/path
            ---
          MD
        end

        it "そのpermalinkにする" do
          expect(described_class.parse(file).permalink).to eq "/existing/path"
        end
      end

      context "先頭にスラッシュがある場合" do
        let(:markdown) do
          <<~MD
            ---
            title: About
            permalink: /team
            ---
            body
          MD
        end

        it "ファイルのディレクトリ配下に配置する" do
          expect(described_class.parse("source/company/about.markdown").permalink).to eq "/company/team"
        end
      end

      context "先頭にスラッシュがない場合" do
        let(:markdown) do
          <<~MD
            ---
            title: Staff
            permalink: staff/list
            ---
            body
          MD
        end

        it "ファイルのディレクトリ配下に配置する" do
          expect(described_class.parse("source/company/staff.markdown").permalink).to eq "/company/staff/list"
        end
      end
    end

    context "フロントマターで日付が指定されている場合" do
      context "Time文字列の場合" do
        let(:markdown) do
          <<~MD
            ---
            title: Test Title
            permalink: /2026/01/test-entry
            date: 2025-01-01 00:00:00
            ---
          MD
        end

        it "Timeにパースする" do
          expect(described_class.parse(file).date).to be_a(Time)
        end
      end

      context "Dateの場合" do
        let(:markdown) do
          <<~MD
            ---
            title: Test Title
            permalink: /2026/01/test-entry
            date: 2025-01-01
            ---
          MD
        end

        it "Timeにパースする" do
          expect(described_class.parse(file).date).to be_a(Time)
        end
      end

      context "String形式の場合" do
        let(:markdown) do
          <<~MD
            ---
            title: Test Title
            permalink: /2026/01/test-entry
            date: "2025-01-01"
            ---
          MD
        end

        it "Timeにパースする" do
          expect(described_class.parse(file).date).to be_a(Time)
        end
      end
    end
  end
end
