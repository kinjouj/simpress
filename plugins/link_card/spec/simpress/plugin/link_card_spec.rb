# frozen_string_literal: true

require "simpress/plugin/link_card"

describe Simpress::Plugin::LinkCard do
  describe ".run" do
    let(:target) do
      build(
        :entry,
        permalink: "/target.html",
        title: "対象タイトル",
        description: "対象の説明文",
        cover: "/images/target.webp",
        content: +"<p>対象本文</p>"
      )
    end

    context "リンク先のエントリが存在する場合" do
      let(:source) do
        build(
          :entry,
          permalink: "/source.html",
          content: +"<p>前</p>\n<!--link-card:/target.html-->\n<p>後</p>"
        )
      end

      it "カードに置き換える" do
        described_class.run([source, target])

        expect(source.content).to include(
          "<p>前</p>",
          "<p>後</p>",
          '<a href="/target.html">',
          '<img src="/images/target.webp" alt="" />',
          "<span>対象タイトル</span>",
          "<span>対象の説明文</span>"
        )
        expect(source.content).not_to include("<!--link-card")
      end
    end

    context "複数のエントリや複数の目印がある場合" do
      let(:other) { build(:entry, permalink: "/other.html", title: "別タイトル", content: +"<p>別本文</p>") }

      let(:source1) do
        build(
          :entry,
          permalink: "/source1.html",
          content: +"<!--link-card:/target.html-->\n<!--link-card:/other.html-->"
        )
      end

      let(:source2) do
        build(
          :entry,
          permalink: "/source2.html",
          content: +"<!--link-card:/target.html-->"
        )
      end

      it "それぞれカードに置き換える" do
        described_class.run([source1, source2, target, other])

        expect(source1.content).to include("<span>対象タイトル</span>", "<span>別タイトル</span>")
        expect(source2.content).to include("<span>対象タイトル</span>")
        expect([source1, source2].map(&:content).join).not_to include("<!--link-card")
      end
    end

    context "リンク先のエントリが存在しない場合" do
      let(:content) { "<p>前</p>\n<!--link-card:/missing.html-->\n<p>後</p>" }
      let(:source) { build(:entry, permalink: "/source.html", content: content.dup) }

      it "置き換えない" do
        described_class.run([source, target])

        expect(source.content).to eq content
      end
    end

    context "目印がないエントリの場合" do
      let(:source) { build(:entry, permalink: "/source.html", content: +"<p>本文</p>") }

      it "contentを変更しない" do
        described_class.run([source, target])

        expect(source.content).to eq "<p>本文</p>"
      end
    end

    context "パーマリンクの末尾にハイフンがある場合" do
      let(:hyphen) { build(:entry, permalink: "/hyphen-", title: "ハイフンタイトル", content: +"<p>本文</p>") }
      let(:source) { build(:entry, permalink: "/source.html", content: +"<!--link-card:/hyphen--->") }

      it "カードに置き換える" do
        described_class.run([source, hyphen])

        expect(source.content).to include('<a href="/hyphen-">', "<span>ハイフンタイトル</span>")
        expect(source.content).not_to include("<!--link-card")
      end
    end
  end

  describe "Filter.preprocess" do
    subject(:filter) { described_class::Filter }

    context "単独行の内部リンクの場合" do
      let(:markdown) do
        <<~MARKDOWN
          前の文章

          [](/first.html)
          [](/second/page.html)

          後の文章
        MARKDOWN
      end

      let(:expected) do
        <<~MARKDOWN
          前の文章

          <!--link-card:/first.html-->
          <!--link-card:/second/page.html-->

          後の文章
        MARKDOWN
      end

      it "目印のコメントに変換する" do
        expect(filter.preprocess(markdown)).to eq expected
      end
    end

    context "変換対象ではない場合" do
      it "変換しない" do
        expect(filter.preprocess("[ラベル](/label.html)")).to eq "[ラベル](/label.html)"
        expect(filter.preprocess("[](https://example.com/page.html)")).to eq "[](https://example.com/page.html)"
        expect(filter.preprocess("abc[](/inline.html)")).to eq "abc[](/inline.html)"
        expect(filter.preprocess("[](/inline.html)abc")).to eq "[](/inline.html)abc"
        expect(filter.preprocess("[](/with space.html)")).to eq "[](/with space.html)"
      end
    end
  end
end
