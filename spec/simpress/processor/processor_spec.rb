# frozen_string_literal: true

require "simpress"
require "simpress/config"
require "simpress/parser"
require "simpress/processor"
require "simpress/plugin/preprocessor"
require "simpress/renderer"
require "simpress/renderer/html"
require "simpress/parser/redcarpet"
require "simpress/parser/redcarpet/renderer"
require "simpress/model/post"
require "simpress/model/category"
require "simpress/paginator/post"

describe Simpress::Processor do
  before do
    stub_const("Simpress::Config::CONFIG_FILE", create_filepath("./test_config.yaml"))
    stub_const("Simpress::Processor::SOURCE_DIR", create_filepath("./source"))
    stub_const("Simpress::Writer::OUTPUT_DIR", create_filepath("./public"))
    stub_const("Simpress::Theme::THEME_DIR", create_filepath("./themes"))
    stub_const("Simpress::Theme::CACHE_DIR", create_filepath("./cache"))
    Simpress::Config.clear
  end

  after do
    Dir.glob(create_filepath("public/*")) {|file| FileUtils.rm_rf(file) }
    Dir.glob(create_filepath("cache/*")) {|file| FileUtils.rm_rf(file) }
  end

  it do
    Simpress::Processor.generate
    expect(File).to exist(create_filepath("public/2000/01/test.html"))
  end

  it "if Simpress::Parser.parse published=false" do
    allow(Simpress::Parser).to receive(:parse) {
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
    }
    Simpress::Processor.generate
    expect(File).not_to exist(create_filepath("public/2000/01/test.html"))
  end
end
