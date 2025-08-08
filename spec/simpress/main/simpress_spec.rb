# frozen_string_literal: true

require "simpress"

describe Simpress do
  before do
    stub_const("Simpress::Config::CONFIG_FILE", fixture("test_config.yaml").path)
    Simpress::Config.clear
    stub_const("Simpress::Theme::THEME_DIR", create_filepath("./themes"))
    stub_const("Simpress::Writer::OUTPUT_DIR", create_filepath("./public"))
    stub_const("Simpress::Processor::SOURCE_DIR", create_filepath("./source"))
    stub_const("Simpress::Plugin::PLUGIN_DIR", create_filepath("./plugins"))
    stub_const("Simpress::Renderer::Html::PAGINATE", 1)
  end

  after do
    Dir.glob(create_filepath("./public/*")) {|file| FileUtils.rm_rf(file) }
  end

  it do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Config.instance).to receive(:preprocessors).and_return([])
    described_class.build
    expect(Simpress::Logger).to have_received(:info).at_least(1).times
    expect(File).to exist(create_filepath("./public/test.html"))
    expect(File).to exist(create_filepath("./public/test2.html"))
    expect(File).to exist(create_filepath("./public/index.html"))
    expect(File).to exist(create_filepath("./public/archives/page/2.html"))
    expect(File).to exist(create_filepath("./public/archives/2000/01/index.html"))
    expect(File).to exist(create_filepath("./public/archives/2000/01/2.html"))
    expect(File).to exist(create_filepath("./public/archives/category/test/index.html"))
    expect(File).to exist(create_filepath("./public/archives/category/test/2.html"))
  end
end
