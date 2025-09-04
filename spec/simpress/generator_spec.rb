# frozen_string_literal: true

require "simpress"
require "simpress/config"
require "simpress/generator"
require "simpress/logger"
require "simpress/parser"
require "simpress/renderer"
require "simpress/renderer/html"
require "simpress/parser/redcarpet"
require "simpress/parser/redcarpet/renderer"
require "simpress/plugin"
require "simpress/model/post"
require "simpress/model/category"
require "simpress/paginator/post"

describe Simpress::Generator do
  before do
    stub_const("Simpress::Config::CONFIG_FILE", create_filepath("./generator/test_config.yaml"))
    stub_const("Simpress::Theme::THEME_DIR", create_filepath("./generator/theme"))
    Simpress::Config.clear
    allow(Simpress::Config.instance).to receive(:source_dir).and_return(create_filepath("./generator/source"))
    allow(Simpress::Config.instance).to receive(:output_dir).and_return(create_filepath("./generator/public"))
  end

  after do
    Dir.glob(create_filepath("./generator/public/*")) {|file| FileUtils.rm_rf(file) }
  end

  it "test" do
    described_class.generate
    expect(File).to exist(create_filepath("./generator/public/2000/01/test.html"))
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
    expect(File).not_to exist(create_filepath("./generator/public/2000/01/test.html"))
  end
end
