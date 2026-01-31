# frozen_string_literal: true

require "simpress/config"

describe Simpress::Config do
  before do
    described_class.clear
  end

  describe ".instance" do
    context "正常な設定ファイルを指定した場合" do
      it "インスタンスが正常に返ってくること" do
        expect(described_class.instance).not_to be_nil
      end
    end

    context "設定ファイルが存在しない場合" do
      it "例外が発生すること" do
        stub_const("Simpress::Config::CONFIG_FILE", "dummy.yaml")
        expect { described_class.instance }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
