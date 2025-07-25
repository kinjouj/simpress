# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

describe Simpress::Theme do
  before do
    stub_const("Simpress::Writer::OUTPUT_DIR", create_filepath("."))
    stub_const("Simpress::Theme::THEME_DIR", create_filepath("."))
    stub_const("Simpress::Theme::CACHE_DIR", create_filepath("."))
  end

  after do
    Dir.glob(File.join(create_filepath("."), "/*.cache")) {|file| FileUtils.rm(file) }
  end

  it :render do
    data = Simpress::Theme.render("post", { post: { title: "test" } })
    expect(data).not_to be_empty
    expect(File.exist?(create_filepath("post.cache"))).to be_truthy
  end

  it :template_exist? do
    expect(Simpress::Theme.template_exist?("test")).to be_falsy
  end
end
