# frozen_string_literal: true

require "simpress/theme"

describe Simpress::Theme do
  before do
    allow(File).to receive(:read).with("theme/post.erb").and_return("post")
    allow(File).to receive(:read).with("theme/page.erb").and_return("page")
  end

  describe ".create_erubis" do
    let(:create_erubis) do
      ->(template) { described_class.send(:create_erubis, template) }
    end

    it "テンプレートごとにErubisがキャッシュされ正しく管理されること" do
      erubis1 = create_erubis.call("post")
      expect(erubis1).to eq(create_erubis.call("post"))

      erubis2 = create_erubis.call("post")
      expect(erubis1).to eq(erubis2)

      erubis3 = create_erubis.call("page")
      expect(erubis1).not_to eq(erubis3)

      expect(Thread.current[:simpress_erubis_caches]).not_to be_empty
      described_class.clear
      expect(Thread.current[:simpress_erubis_caches]).to be_nil

      expect { create_erubis.call("test") }.to raise_error(RuntimeError)

      allow(File).to receive(:read) { raise RuntimeError }
      expect { create_erubis.call("post") }.to raise_error(RuntimeError)
    end
  end

  describe ".render" do
    it "テンプレートをレンダリングして結果を返すこと" do
      data = described_class.render("post", { post: { title: "test" } })
      expect(data).not_to be_empty
    end
  end

  describe ".exist?" do
    it "テンプレートが存在するかどうかを正しく判定できること" do
      expect(described_class).to exist("post")
      expect(described_class).not_to exist("test")
    end
  end
end
