# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/plugin"
require "simpress/plugin/recent_posts"
require "simpress/theme"

describe Simpress::Plugin::RecentPosts do
  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
    allow(Simpress::Config.instance).to receive(:theme_dir).and_return(File.expand_path(".", __dir__))
  end

  after do
    Simpress::Context.clear
  end

  describe ".run" do
    it "正常に最近の投稿がContextに格納されること" do
      described_class.run([*1..30], nil, nil)
      content = Simpress::Context[:sidebar_recent_posts_content]
      expect(content.chomp).to eq([*1..10].join("\n"))
    end

    context "template_exist?がfalseを返した場合" do
      it "Contextにデータが設定されないこと" do
        allow(Simpress::Theme).to receive(:exist?).and_return(false)
        described_class.run([*1..30], nil, nil)
        expect { Simpress::Context[:sidebar_recent_posts_content] }.to raise_error("'sidebar_recent_posts_content' missing")
      end
    end
  end
end
