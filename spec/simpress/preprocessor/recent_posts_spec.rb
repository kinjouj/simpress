# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/preprocessor"
require "simpress/preprocessor/recent_posts"
require "simpress/theme"

describe Simpress::Preprocessor::RecentPosts do
  before do
    stub_const("Simpress::Theme::THEME_DIR", File.expand_path(".", __dir__))
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
  end

  after do
    Simpress::Context.clear
  end

  context "run" do
    it "successful" do
      described_class.run([*1..30], nil, nil)
      content = Simpress::Context[:sidebar_recent_posts_content]
      expect(content.chomp).to eq([*1..10].join("\n"))
    end

    it "MODEがhtmlじゃない場合" do
      allow(Simpress::Config.instance).to receive(:mode).and_return(:json)
      described_class.run(nil, nil, nil)
      expect { Simpress::Context[:sidebar_recent_posts_content] }.to raise_error("'sidebar_recent_posts_content' missing")
    end

    it "template_exist?がfalseを返した場合" do
      allow(Simpress::Theme).to receive(:template_exist?).and_return(false)
      described_class.run([*1..30], nil, nil)
      expect { Simpress::Context[:sidebar_recent_posts_content] }.to raise_error("'sidebar_recent_posts_content' missing")
    end
  end
end
