# frozen_string_literal: true

require "simpress/config"
require "simpress/theme"
require "simpress/context"

describe Simpress::Theme do
  before do
    stub_const("Simpress::Theme::THEME_DIR", create_filepath("."))
    stub_const("Simpress::Theme::OUTPUT_DIR", create_filepath("."))
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

  it :render_index do
    allow(File).to receive(:write).with(create_filepath("test.html"), anything)
    Simpress::Theme.render_index("test.html", {})
  end

  it :render_post do
    allow(File).to receive(:write).with(create_filepath("test.html"), "test\n")
    Simpress::Theme.render_post("test.html", { post: { title: "test" } })
  end

  it :render_page do
    allow(File).to receive(:write).with(create_filepath("test.html"), anything)
    Simpress::Theme.render_page("test.html", {})
  end

  it :template_exist? do
    expect(Simpress::Theme.template_exist?("test")).to be_falsy
  end
end
