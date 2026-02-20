# frozen_string_literal: true

require "simpress/parser"

describe Simpress::Parser do
  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
  end

  context "正常なMarkdownをパースする場合" do
    it "タイトル、パーマリンク、レイアウト、公開状態、カテゴリを正しく取得できること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2025-01-01 00:00:00
          permalink: /test.html
          categories:
          - test
          ---

          test
        MARKDOWN
      }
      post = described_class.parse("test.markdown")
      expect(post).not_to be_nil
      expect(post.title).to eq("test")
      expect(post.permalink).to eq("/test.html")
      expect(post.layout).to eq(:post)
      expect(post.draft).to be_falsy
      expect(post.categories).to eql([Simpress::Category.fetch("test")])
    end
  end

  context "パーマリンクが存在しない場合" do
    it "ファイル名と日付から自動生成されること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2000-01-01 00:00:00
          ---

          test
        MARKDOWN
      }
      post = described_class.parse("dummy.md")
      expect(post).not_to be_nil
      expect(post.permalink).to eq("/2000/01/dummy")
    end
  end

  context "dateが無い場合" do
    it "ファイル名に日付があればそれを使用してパースできること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          ---

          test
        MARKDOWN
      }
      post = described_class.parse("2010-01-01-dummy.markdown")
      expect(post).not_to be_nil
    end

    it "ファイル名にも日付要素がない場合は ParserError が発生すること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          ---

          test
        MARKDOWN
      }
      expect { described_class.parse("dummy.markdown") }.to raise_error(Simpress::Parser::ParseError)
    end
  end

  context "dateが不正な値の場合" do
    it "正しい日付フォーマットであれば DateTime に変換されること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2020-01-01 00:00
          ---

          test
        MARKDOWN
      }
      post = described_class.parse("dummy.markdown")
      expect(post).not_to be_nil
      expect(post.date).not_to be_nil
      expect(post.date).to eq(Time.new(2020, 1, 1))
    end

    it "不正値の場合はInvalidDateParseErrorが発生すること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: abc
          ---

          test
        MARKDOWN
      }
      expect { described_class.parse("dummy.markdown") }.to raise_error(Simpress::Parser::ParseError)
    end
  end

  context "layoutが指定されている場合" do
    it "layoutが正しく設定されること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2000-01-01 00:00:00
          permalink: /test.html
          layout: page
          categories: "test"
          ---


          test
        MARKDOWN
      }
      file = File.expand_path("test4.markdown", __dir__)
      post = described_class.parse(file)
      expect(post).not_to be_nil
      expect(post.layout).to eq(:page)
    end
  end

  context "draftが指定されている場合" do
    it "公開状態が正しく反映されること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2000-01-01 00:00:00
          draft: false
          ---

          test
        MARKDOWN
      }
      post = described_class.parse("dummy.markdown")
      expect(post).not_to be_nil
      expect(post.draft).to be_falsey
    end
  end

  context "coverヘッダや本文画像がある場合" do
    it "coverが正しく設定されること(ヘッダ優先)" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2000-01-01 00:00:00
          cover: /images/test.png
          ---


          test
        MARKDOWN
      }
      post = described_class.parse("dummy.markdown")
      expect(post).not_to be_nil
      expect(post.cover).to eq("/images/test.png")
    end

    it "coverが本文の最初の画像から取得されること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2000-01-01 00:00:00
          ---

          ![](/images/test.jpg)
        MARKDOWN
      }

      post = described_class.parse("dummy.markdown")
      expect(post).not_to be_nil
      expect(post.cover).to eq("/images/test.jpg")
    end
  end

  context "descriptionがある場合" do
    it "descriptionが正しく取得できること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2000-01-01 00:00:00
          description: aaa bbb ccc
          ---

          test
        MARKDOWN
      }

      post = described_class.parse("dummy.markdonw")
      expect(post).not_to be_nil
      expect(post.description).to eq("aaa bbb ccc")
    end
  end

  context "categoriesが配列でない場合" do
    it "単一カテゴリを配列に変換して取得できること" do
      allow(File).to receive(:read) {
        <<~MARKDOWN
          ---
          title: test
          date: 2000-01-01 00:00:00
          categories: test
          ---

          test
        MARKDOWN
      }

      post = described_class.parse("dummy.markdown")
      expect(post).not_to be_nil
      expect(post.categories).to eql([Simpress::Category.fetch("test")])
    end
  end
end
