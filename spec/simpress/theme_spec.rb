# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

describe Simpress::Theme do
  before do
    stub_const("Simpress::Theme::THEME_DIR", fixture(".").path)
  end

  it :render do
    data = described_class.render("post", { post: { title: "test" } })
    expect(data).not_to be_empty
  end

  it :template_exist? do
    expect(described_class).not_to be_template_exist("test")
  end
end
