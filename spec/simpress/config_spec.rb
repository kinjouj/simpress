# frozen_string_literal: true

require "simpress/config"

describe Simpress::Config do
  let(:config_data) do
    {
      default: {
        mode: "html",
        host: "https://example.com",
        logging: true,
        paginate: 10,
        plugins: ["test_plugin"]
      }
    }
  end

  let(:taxonomies) do
    { "categories" => { "Ruby" => "ruby" }, "tags" => {} }
  end

  before do
    allow(Psych).to receive(:load_file).with(Simpress::Config::CONFIG_FILE, any_args).and_return(config_data)
    allow(File).to receive(:exist?).with(Simpress::Config::TAXONOMIES_FILE).and_return(true)
    allow(Psych).to receive(:load_file).with(Simpress::Config::TAXONOMIES_FILE).and_return(taxonomies)
    described_class.clear
  end

  describe ".instance" do
    it "設定ファイルを読み込む" do
      config = described_class.instance
      expect(config.mode).to eq "html"
      expect(config.host).to eq "https://example.com"
      expect(config.logging).to be true
      expect(config.paginate).to eq 10
      expect(config.plugins).to eq ["test_plugin"]
      expect(config.taxonomies).to eq taxonomies
    end
  end

  describe ".clear" do
    it "新しいインスタンスを返す" do
      obj = described_class.instance
      described_class.clear
      expect(obj).not_to be described_class.instance
    end
  end

  describe "#taxonomies" do
    context "taxonomies.yamlが存在しない場合" do
      before do
        allow(File).to receive(:exist?).with(Simpress::Config::TAXONOMIES_FILE).and_return(false)
      end

      it "空のハッシュを返す" do
        expect(described_class.instance.taxonomies).to eq({})
      end
    end

    context "taxonomies.yamlが空の場合" do
      before do
        allow(Psych).to receive(:load_file).with(Simpress::Config::TAXONOMIES_FILE).and_return(nil)
      end

      it "空のハッシュを返す" do
        expect(described_class.instance.taxonomies).to eq({})
      end
    end
  end
end
