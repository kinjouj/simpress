# frozen_string_literal: true

require "simpress/plugin/preprocessor/categories_content"

describe Simpress::Plugin::Preprocessor::CategoriesContent do
  before do
    stub_const("Simpress::Theme::THEME_DIR", File.expand_path(".", __dir__))
    stub_const("Simpress::Theme::CACHE_DIR", File.expand_path(".", __dir__))
    Simpress::Context.clear
  end

  after do
    Dir[File.join(File.expand_path(".", __dir__), "/*.cache")].each {|file| FileUtils.rm_rf(file) }
  end

  let(:category) { Simpress::Model::Category.new("test") }

  it "successful" do
    Simpress::Plugin::Preprocessor::CategoriesContent.run(nil, nil, { test: category })
    expect(Simpress::Context[:sidebar_categories_content]).not_to be_empty
  end

  it "modeがhtmlではない場合" do
    allow(Simpress::Config.instance).to receive(:mode).and_return(:json)
    Simpress::Plugin::Preprocessor::CategoriesContent.run(nil, nil, { test: category })
    expect { Simpress::Context[:sidebar_categories_content] }.to raise_error("sidebar_categories_content missing")
  end

  it "template_exist?がfalseの場合" do
    allow(Simpress::Theme).to receive(:template_exist?).and_return(false)
    Simpress::Plugin::Preprocessor::CategoriesContent.run(nil, nil, { test: category })
    expect { Simpress::Context[:sidebar_categories_content] }.to raise_error("sidebar_categories_content missing")
  end
end
