# frozen_string_literal: true

require "simpress/theme"

describe Simpress::Theme do
  before do
    described_class.clear
  end

  describe ".create_tilt" do
    let(:create_tilt) { ->(template) { described_class.send(:create_tilt, template) } }

    before do
      allow(File).to receive(:binread).with("theme/post.erb").and_return("template content".dup)
    end

    it "テンプレートごとにErubisがキャッシュされ正しく管理されること" do
      tilt1 = create_tilt.call("post")
      expect(tilt1).to eq(create_tilt.call("post"))

      tilt2 = create_tilt.call("post")
      expect(tilt1).to eq(tilt2)
    end

    it "Erubisのロードに失敗したときに例外を返す" do
      allow(Tilt::ErubiTemplate).to receive(:new).and_raise(StandardError, "Error")
      expect { create_tilt.call("post") }.to raise_error(StandardError)
    end
  end

  describe ".render" do
    before do
      allow(Tilt::ErubiTemplate).to receive(:new).with("theme/post.erb")
                                                 .and_return(Tilt::ErubiTemplate.new { "<%= @foo %>, <%= @bar %>" })
    end

    it "テンプレートをレンダリングして結果を返すこと" do
      data = described_class.render("post", { foo: "Hello", bar: "World" })
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
