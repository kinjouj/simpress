# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "simpress/model/category"
require "simpress/model/post"
require "simpress/renderer/html/page"
require "simpress/paginator/post"
require "simpress/theme"
require "simpress/writer"

describe Simpress::Renderer::Html::Page do
  before do
    stub_const("Simpress::Theme::THEME_DIR", create_filepath("./themes"))
    stub_const("Simpress::Writer::OUTPUT_DIR", create_filepath("./public"))
  end

  after do
    Dir.glob(create_filepath("./public/*")) {|file| FileUtils.rm_rf(file) }
  end

  let(:post) do
    Simpress::Model::Post.new(
      title: "test",
      content: "test",
      layout: :page,
      permalink: "/test.html",
      date: DateTime.now,
      toc: [],
      categories: [],
      cover: "/images/no_image.png",
      published: true
    )
  end

  it "test" do
    allow(File).to receive(:write).with(create_filepath("public/test.html"), anything)
    Simpress::Renderer::Html::Page.build(post)
  end
end
