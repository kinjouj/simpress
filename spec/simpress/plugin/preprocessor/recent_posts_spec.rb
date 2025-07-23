# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/plugin/preprocessor"
require "simpress/theme"
require "simpress/plugin/preprocessor/recent_posts"

describe Simpress::Plugin::Preprocessor::RecentPosts do
  before do
    stub_const("Simpress::Theme::THEME_DIR", File.expand_path(".", __dir__))
    stub_const("Simpress::Theme::CACHE_DIR", File.expand_path(".", __dir__))
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
  end

  after do
    Dir.glob(File.expand_path("./*.cache", __dir__)) {|file| FileUtils.rm_rf(file) }
    Simpress::Context.clear
  end

  context "run" do
    it "successful" do
      Simpress::Plugin::Preprocessor::RecentPosts.run([*1..30], nil, nil)
      content = Simpress::Context[:sidebar_recent_posts_content]
      expect(content.chomp).to eq([*1..10].join("\n"))
    end

    it "MODEがhtmlじゃない場合" do
      allow(Simpress::Config.instance).to receive(:mode).and_return(:json)
      Simpress::Plugin::Preprocessor::RecentPosts.run(nil, nil, nil)
      expect { Simpress::Context[:sidebar_recent_posts_content] }.to raise_error("sidebar_recent_posts_content missing")
    end

    it "template_exist?がfalseを返した場合" do
      allow(Simpress::Theme).to receive(:template_exist?).and_return(false)
      Simpress::Plugin::Preprocessor::RecentPosts.run([*1..30], nil, nil)
      expect { Simpress::Context[:sidebar_recent_posts_content] }.to raise_error("sidebar_recent_posts_content missing")
    end
  end
end
