# frozen_string_literal: true

require "simpress/plugin/scss"

describe Simpress::Plugin::SCSS do
  before do
    allow(Simpress::Writer).to receive(:write)
  end

  describe ".run" do
    before do
      allow(File).to receive(:exist?).and_return(true)
    end

    context "ファイルが存在する場合" do
      before do
        allow(Sass).to receive(:compile).and_return(Struct.new(:css).new("body { color: red; }"))
      end

      it "エラーなく実行されること" do
        described_class.run
        expect(Simpress::Writer).to have_received(:write).with("css/style.css", "body { color: red; }")
      end
    end

    context "Sass.compileがエラーになった場合" do
      it "SassのエラーがRuntimeErrorとして再送出されること" do
        error = Sass::CompileError.allocate
        allow(error).to receive(:full_message).and_return("Sass Syntax Error!")
        allow(Sass).to receive(:compile).and_raise(error)

        expect { described_class.run }.to raise_error(RuntimeError, "Sass Syntax Error!")
      end
    end
  end

  context "ファイルが存在しない場合" do
    before do
      allow(File).to receive(:exist?).and_return(false)
    end

    it "何もせず正常終了すること" do
      described_class.run
      expect(Simpress::Writer).not_to have_received(:write)
    end
  end
end
