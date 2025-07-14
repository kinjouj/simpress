# frozen_string_literal: true

require "simpress/config"
require "simpress/markdown"
require "simpress/parser"
require "simpress/parser/redcarpet"
require "simpress/parser/redcarpet/filter"
require "simpress/parser/redcarpet/markdown"
require "simpress/parser/redcarpet/renderer"
require "simpress/model/category"
require "simpress/model/post"

describe Simpress::Parser do
  it do
    post = Simpress::Parser.parse(fixture("test.markdown").path)
    expect(post).not_to be_nil
    expect(post.title).to eq("test1")
    expect(post.permalink).to eq("/test.html")
    expect(post.layout).to eq(:post)
    expect(post.published).to be_truthy
    expect(post.categories).to eql(["test"])
  end

  it "permalinkが無い場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
date: 2000-01-01 00:00:00
---

test
MARKDOWN
    }
    post = Simpress::Parser.parse("dummy.markdown")
    expect(post).not_to be_nil
    expect(post.permalink).to eq("/2000/01/dummy.html")
  end

  it "dateが無い場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
---

test
MARKDOWN
    }
    post = Simpress::Parser.parse("2010-01-01-dummy.markdown")
    expect(post).not_to be_nil
  end

  it "dateがなくてファイル名にも日付要素がない場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
---

test
MARKDOWN
    }
    expect { Simpress::Parser.parse("dummy.markdown") }.to raise_error("invalid date")
  end

  it "dateが不正値な場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
date: 2020-01-01 00:00
---

test
MARKDOWN
    }
    post = Simpress::Parser.parse("dummy.markdown")
    expect(post).not_to be_nil
    expect(post.date).not_to be_nil
    expect(post.date).to eq(Date.new(2020, 1, 1).to_datetime)
  end

  it "layoutがある場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
date: 2000-01-01 00:00:00
layout: page
categories: "test"
---


test
MARKDOWN
    }
    file = File.expand_path("test4.markdown", __dir__)
    post = Simpress::Parser.parse(file)
    expect(post).not_to be_nil
    expect(post.layout).to eq(:page)
  end

  it "publishedがある場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
date: 2000-01-01 00:00:00
published: false
---

test
MARKDOWN
    }
    post = Simpress::Parser.parse("dummy.markdown")
    expect(post).not_to be_nil
    expect(post.published).to be_falsey
  end

  it "cover headerがある場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
date: 2000-01-01 00:00:00
cover: /test.png
---


test
MARKDOWN
    }
    post = Simpress::Parser.parse("dummy.markdown")
    expect(post).not_to be_nil
    expect(post.cover).to eq("/test.png")
  end

  it "markdownの画像タグがある場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
date: 2000-01-01 00:00:00
---

![](/test.jpg)
MARKDOWN
    }

    post = Simpress::Parser.parse("dummy.markdown")
    expect(post).not_to be_nil
    expect(post.cover).to eq("/test.jpg")
  end

  it "categoriesが配列表記じゃない場合" do
    allow(File).to receive(:read) {
      <<MARKDOWN
---
title: test
date: 2000-01-01 00:00:00
categories: test
---

test
MARKDOWN
    }

    post = Simpress::Parser.parse("dummy.markdown")
    expect(post).not_to be_nil
    expect(post.categories).to eql(["test"])
  end

  it "markdownの解析に失敗した場合" do
    allow(File).to receive(:read)
    allow(Simpress::Markdown).to receive(:parse) { nil }
    expect { Simpress::Parser.parse("dummy.markdown") }.to raise_error("parse failed: dummy.markdown")
  end
end
