# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

describe Simpress::Theme do
  before do
    allow(Simpress::Config.instance).to receive(:theme_dir).and_return(fixture("theme").path)
  end

  it :create_erubis do
    erubis = described_class.create_erubis("post")
    expect(erubis).to eq(described_class.create_erubis("post"))
    expect(Thread.current[Simpress::Theme::KEY]).not_to be_empty
    described_class.clear
    expect(Thread.current[Simpress::Theme::KEY]).to be_nil
  end

  it :render do
    data = described_class.render("post", { post: { title: "test" } })
    expect(data).not_to be_empty
  end

  it :template_exist? do
    expect(described_class).not_to be_template_exist("test")
  end
end
