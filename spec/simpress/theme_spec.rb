# frozen_string_literal: true

require "simpress/theme"

describe Simpress::Theme do
  describe ".create_tilt" do
    let(:eruby_double) { instance_double(Tilt::ErubiTemplate, render: "template content") }
    let(:create_tilt) { ->(template) { described_class.send(:create_tilt, template) } }

    before do
      described_class.clear
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
      described_class.clear
      allow(Tilt::ErubiTemplate).to receive(:new).with("theme/post.erb")
                                                 .and_return(Tilt::ErubiTemplate.new { "<%= @foo %>, <%= @bar %>" })
    end

    it "テンプレートをレンダリングして結果を返すこと" do
      data = described_class.render("post", { foo: "Hello", bar: "World" })
      expect(data).to eq("Hello, World")
    end
  end

  describe ".exist?" do
    it "テンプレートが存在するかどうかを正しく判定できること" do
      expect(described_class).not_to exist("test")
    end
  end
end
