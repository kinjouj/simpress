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
      let(:content) do
        <<~HTML
          <p>前</p>
          <!--link-card:/target.html-->
          <p>後</p>
        HTML
      end

      let(:source) do
        build(:entry, permalink: "/source.html", content: content.dup)
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
      let(:other) do
        build(:entry, permalink: "/other.html", title: "別タイトル", content: +"<p>別本文</p>")
      end

      let(:content1) do
        <<~HTML
          <!--link-card:/target.html-->
          <!--link-card:/other.html-->
        HTML
      end

      let(:source1) do
        build(:entry, permalink: "/source1.html", content: content1.dup)
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
      let(:content) do
        <<~HTML
          <p>前</p>
          <!--link-card:/missing.html-->
          <p>後</p>
        HTML
      end

      let(:source) do
        build(:entry, permalink: "/source.html", content: content.dup)
      end

      it "置き換えない" do
        described_class.run([source, target])

        expect(source.content).to eq content
      end
    end

    context "目印がないエントリの場合" do
      let(:source) do
        build(:entry, permalink: "/source.html", content: +"<p>本文</p>")
      end

      it "contentを変更しない" do
        described_class.run([source, target])

        expect(source.content).to eq "<p>本文</p>"
      end
    end

    context "パーマリンクの末尾にハイフンがある場合" do
      let(:hyphen) do
        build(:entry, permalink: "/hyphen-", title: "ハイフンタイトル", content: +"<p>本文</p>")
      end

      let(:source) do
        build(:entry, permalink: "/source.html", content: +"<!--link-card:/hyphen--->")
      end

      it "カードに置き換える" do
        described_class.run([source, hyphen])

        expect(source.content).to include('<a href="/hyphen-">', "<span>ハイフンタイトル</span>")
        expect(source.content).not_to include("<!--link-card")
      end
    end
  end

  describe "Filter.preprocess" do
    subject(:filter) do
      described_class::Filter
    end

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
      context "ラベル付きのリンクの場合" do
        it "変換しない" do
          data = "[ラベル](/label.html)"
          expect(filter.preprocess(data)).to eq data
        end
      end

      context "外部URLの場合" do
        it "変換しない" do
          data = "[](https://example.com/page.html)"
          expect(filter.preprocess(data)).to eq data
        end
      end

      context "前に文字がある場合" do
        it "変換しない" do
          data = "abc[](/inline.html)"
          expect(filter.preprocess(data)).to eq data
        end
      end

      context "後ろに文字がある場合" do
        it "変換しない" do
          data = "[](/inline.html)abc"
          expect(filter.preprocess(data)).to eq data
        end
      end

      context "パスに空白がある場合" do
        it "変換しない" do
          data = "[](/with space.html)"
          expect(filter.preprocess(data)).to eq data
        end
      end
    end
  end
end
