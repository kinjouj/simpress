# frozen_string_literal: true

require "simpress/config"

describe Simpress::Config do
  before do
    described_class.clear
  end

  describe "initialize" do
    context "正常な設定ファイルを指定した場合" do
      it "successful" do
        expect(described_class.instance).not_to be_nil
      end
    end

    context "設定ファイルが存在しない場合" do
      it "例外が発生すること" do
        stub_const("Simpress::Config::CONFIG_FILE", "dummy.yaml")
        expect { described_class.instance }.to raise_error(Errno::ENOENT)
      end
    end

    context "Psych.load_fileがnilを返した場合" do
      it "不正値として例外が発生すること" do
        allow(Psych).to receive(:load_file).and_return(nil)
        expect { described_class.instance }.to raise_error(CH::SchemaViolationError)
      end
    end
  end
end
