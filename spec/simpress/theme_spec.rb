# frozen_string_literal: true

require "simpress/theme"

describe Simpress::Theme do
  describe ".create_erubis" do
    let(:eruby_double) { instance_double(Erubis::Eruby, evaluate: "rendered content") }
    let(:create_erubis) { ->(template) { described_class.send(:create_erubis, template) } }

    before do
      allow(Erubis::Eruby).to receive(:load_file).with("theme/post.erb", { engine: :fast })
                                                 .and_return(eruby_double)
    end

    it "テンプレートごとにErubisがキャッシュされ正しく管理されること" do
      erubis1 = create_erubis.call("post")
      expect(erubis1).to eq(create_erubis.call("post"))

      erubis2 = create_erubis.call("post")
      expect(erubis1).to eq(erubis2)

      expect(Thread.current[:simpress_erubis_caches]).not_to be_empty
      described_class.clear
      expect(Thread.current[:simpress_erubis_caches]).to be_nil

      expect { create_erubis.call("test") }.to raise_error(RuntimeError)
    end

    it "Erubisのロードに失敗したときに例外を返す" do
      allow(Erubis::Eruby).to receive(:load_file).and_raise(StandardError, "Error")
      expect { create_erubis.call("post") }.to raise_error("Failed template error: Error")
    end
  end

  describe ".render" do
    let(:eruby_double) { instance_double(Erubis::Eruby, evaluate: "rendered content") }

    before do
      allow(Erubis::Eruby).to receive(:load_file).with("theme/post.erb", { engine: :fast })
                                                 .and_return(eruby_double)
    end

    it "テンプレートをレンダリングして結果を返すこと" do
      data = described_class.render("post", { post: { title: "test" } })
      expect(data).not_to be_empty
    end
  end

  describe ".exist?" do
    it "テンプレートが存在するかどうかを正しく判定できること" do
      expect(described_class).not_to exist("test")
    end
  end
end
