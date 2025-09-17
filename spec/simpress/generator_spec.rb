# frozen_string_literal: true

require "simpress"
require "simpress/config"
require "simpress/generator"
require "simpress/generator/html"
require "simpress/logger"
require "simpress/parser"
require "simpress/parser/redcarpet"
require "simpress/parser/redcarpet/renderer"
require "simpress/plugin"
require "simpress/model/post"
require "simpress/model/category"
require "simpress/paginator/post"

describe Simpress::Generator do
  before do
    allow(described_class).to receive(:source_dir).and_return(fixture("generator/source").path)
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
    allow(Simpress::Config.instance).to receive(:theme_dir).and_return(fixture("generator/theme").path)
    allow(Simpress::Config.instance).to receive(:output_dir).and_return(fixture("generator/public").path)
    allow(Simpress::Config.instance).to receive(:plugin_dir).and_return(fixture("generator/plugins").path)
    allow(Simpress::Config.instance).to receive(:plugins).and_return([])
  end

  after do
    Dir.glob(fixture("generator/public/*")) {|file| FileUtils.rm_rf(file) }
  end

  it "test" do
    allow(Simpress::Logger).to receive(:info)
    described_class.generate
    expect(File).to exist(fixture("generator/public/2000/01/test.html").path)
    expect(Simpress::Logger).to have_received(:info).at_least(1)
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
    expect(File).not_to exist(fixture("generator/public/2000/01/test.html").path)
  end
end
