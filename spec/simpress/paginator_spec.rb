# frozen_string_literal: true

require "simpress/paginator"
require "simpress/paginator/index"
require "simpress/paginator/post"

describe Simpress::Paginator do
  it "successful" do
    paginator1 = described_class.builder.maxpage(10).page(2).build
    expect(paginator1).to be_is_a(Simpress::Paginator::Index)

    paginator2 = described_class.builder.maxpage(10).page(2).prefix("/abc").build
    expect(paginator2).to be_is_a(Simpress::Paginator::Index)

    paginator3 = described_class.builder.posts([1, 2, 3]).build
    expect(paginator3).to be_is_a(Simpress::Paginator::Post)
  end

  it "error" do
    expect { described_class.builder.build }.to raise_error("ERROR")
  end
end
