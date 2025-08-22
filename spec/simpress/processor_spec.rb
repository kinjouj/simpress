# frozen_string_literal: true

require "simpress"
require "simpress/config"
require "simpress/parser"
require "simpress/processor"
require "simpress/preprocessor"
require "simpress/renderer"
require "simpress/renderer/html"
require "simpress/parser/redcarpet"
require "simpress/parser/redcarpet/renderer"
require "simpress/model/post"
require "simpress/model/category"
require "simpress/paginator/post"

describe Simpress::Processor do
  before do
    stub_const("Simpress::Config::CONFIG_FILE", create_filepath("./processor/test_config.yaml"))
    Simpress::Config.clear
    stub_const("Simpress::Processor::SOURCE_DIR", create_filepath("./processor/source"))
    stub_const("Simpress::Writer::OUTPUT_DIR", create_filepath("./processor/public"))
    stub_const("Simpress::Theme::THEME_DIR", create_filepath("./processor/theme"))
  end

  after do
    Dir.glob(create_filepath("processor/public/*")) {|file| FileUtils.rm_rf(file) }
  end

  it "test" do
    described_class.generate
    expect(File).to exist(create_filepath("processor/public/2000/01/test.html"))
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
    described_class.generate
    expect(File).not_to exist(create_filepath("processor/public/2000/01/test.html"))
  end
end
