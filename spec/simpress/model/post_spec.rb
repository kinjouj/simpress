# frozen_string_literal: true

require "simpress/model/post"

describe Simpress::Model::Post do
  let(:params) do
    {
      id: "abc",
      title: "title",
      content: "<p>content\n 123</p>",
      toc: [],
      date: DateTime.now,
      permalink: "/test.html",
      categories: [],
      cover: "/images/no_image.png",
      layout: :post,
      published: true
    }
  end

  it "successful" do
    post = described_class.new(params)
    expect(post).to be_is_a(described_class)
    expect(post.to_s).to eq("title: /test.html")
  end
end
