# frozen_string_literal: true

require "simpress/theme"

describe Simpress::Theme do
  before do
    described_class.clear
  end

  describe ".render" do
    before do
      allow(Tilt::ErubiTemplate).to receive(:new).with("theme/page.erb", escape: true)
                                                 .and_return(Tilt::ErubiTemplate.new { "<%= @foo %>, <%= @bar %>" })
    end

    it "テンプレートをレンダリングして結果を返すこと" do
      data = described_class.render("page", { foo: "Hello", bar: "World" })
      expect(data).to eq("Hello, World")
    end
  end

  describe ".render_partial" do
    before do
      post_template = Tilt::ErubiTemplate.new { "<%= render_partial('test', { msg: @msg }) %>" }
      allow(described_class).to receive(:create_tilt).with("post").and_return(post_template)
      allow(described_class).to receive(:create_tilt).with("test").and_return(Tilt::ErubiTemplate.new { "<%= @msg %>" })
    end

    it "テンプレート内でrender_paritalで別テンプレートの描画が正しく結果を返すこと" do
      expect(described_class.render_partial("post", { msg: "hoge fuga foobar" })).to eq("hoge fuga foobar")
    end
  end
end
