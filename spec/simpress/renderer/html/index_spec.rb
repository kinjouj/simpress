# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "simpress/model/category"
require "simpress/model/post"
require "simpress/theme"
require "simpress/renderer/html/index"
require "simpress/paginator/index"
require "simpress/writer"

describe Simpress::Renderer::Html::Index do
  before do
    stub_const("Simpress::Theme::THEME_DIR", create_filepath("./themes"))
    stub_const("Simpress::Writer::OUTPUT_DIR", create_filepath("./public"))
    stub_const("Simpress::Theme::CACHE_DIR", create_filepath("./cache"))
  end

  after do
    Dir.glob(create_filepath("./cache/*.cache")) {|file| FileUtils.rm_rf(file) }
    Dir.glob(create_filepath("./public/*")) {|file| FileUtils.rm_rf(file) }
  end

  let(:post) do
    Simpress::Model::Post.new(
      title: "test",
      content: "test",
      toc: [],
      date: DateTime.now,
      permalink: "/test.html",
      categories: [],
      cover: "/images/no_image.png",
      layout: :post,
      published: false
    )
  end

  it do
    allow(File).to receive(:write).with(create_filepath("public/index.html"), anything)
    Simpress::Renderer::Html::Index.build([post], Simpress::Paginator::Index.new(1, 1))
  end

  it do
    allow(File).to receive(:write).with(create_filepath("public/archives/page/2.html"), anything)
    Simpress::Renderer::Html::Index.build([post], Simpress::Paginator::Index.new(2, 10))
  end
end
