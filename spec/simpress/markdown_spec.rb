# frozen_string_literal: true

require "simpress/markdown"

describe Simpress::Markdown do
  it "parser test" do
    data = <<MARKDOWN
---
title: test
date: 2025-01-01 00:00:00
categories:
  - test
---

test
MARKDOWN

    metadata, body = Simpress::Markdown.parse(data)
    expect(metadata).not_to be_nil
    expect(body).not_to be_nil
    expect { Simpress::Markdown.parse("") }.to raise_error("PARSE ERROR")
  end
end
