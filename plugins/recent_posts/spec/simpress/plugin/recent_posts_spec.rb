# frozen_string_literal: true

require "oj"
require "simpress/config"
require "simpress/context"
require "simpress/plugin"
require "simpress/plugin/recent_posts"
require "simpress/theme"

describe Simpress::Plugin::RecentPosts do
  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return("html")
  end

  after do
    Simpress::Context.clear
  end

  let(:posts) { [*1..30] }

  describe ".run" do
    it "正常に最近の投稿がContextに格納されること" do
      described_class.run(posts)
      expect(Simpress::Context[:recent_posts]).not_to be_empty
    end

    context "modeがjsonだった場合" do
      before do
        allow(Simpress::Config.instance).to receive(:paginate).and_return(5)
        allow(Simpress::Config.instance).to receive(:mode).and_return("json")
        allow(Simpress::Writer).to receive(:write)
      end

      it "recent_posts.jsonがファイルとして出力されること" do
        described_class.run(posts)
        expect(Simpress::Writer).to have_received(:write).with("recent_posts.json", Oj.dump([*1..5]))
      end
    end

    context "modeがhtmlでもjsonでもない場合" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("hoge")
      end

      it "エラーが送出されること" do
        expect { described_class.run([*1..30]) }.to raise_error("Error")
      end
    end
  end
end
