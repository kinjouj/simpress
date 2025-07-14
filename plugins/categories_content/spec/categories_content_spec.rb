# frozen_string_literal: true

require "simpress/plugin/preprocessor/categories_content"

describe Simpress::Plugin::Preprocessor::CategoriesContent do
  before do
    stub_const("Simpress::Theme::THEME_DIR", File.expand_path(".", __dir__))
    stub_const("Simpress::Theme::CACHE_DIR", File.expand_path(".", __dir__))
  end

  after do
    Dir.glob(File.join(File.expand_path(".", __dir__), "/*.cache")) {|file| FileUtils.rm_rf(file) }
  end

  let(:category) {
    Simpress::Model::Category.new("test")
  }

  it "successful" do
    Simpress::Plugin::Preprocessor::CategoriesContent.run(nil, nil, { test: category })
    expect(Simpress::Context[:sidebar_categories_content]).not_to be_empty
  end
end
