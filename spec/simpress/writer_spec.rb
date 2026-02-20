# frozen_string_literal: true

require "tmpdir"
require "simpress/writer"

describe Simpress::Writer do
  before do
    tmpdir = Dir.mktmpdir
    allow(Simpress::Config).to receive(:output_dir).and_return(tmpdir)
  end

  after do
    FileUtils.remove_entry(Simpress::Config.output_dir, true)
  end

  describe ".write" do
    it "指定したパスにファイルを書き込めること" do
      described_class.write("test.txt", "hoge")
      expect(File).to exist(File.join(Simpress::Config.output_dir, "test.txt"))
    end

    context "既に存在するファイルに書き込もうとした場合" do
      it "RuntimeErrorが発生すること" do
        described_class.write("test2.txt", "hoge")
        expect { described_class.write("test2.txt", "fuga") }.to raise_error(RuntimeError)
      end
    end

    context "ブロックを要求した場合" do
      it "正しいファイルパスが渡されること" do
        described_class.write("test3.txt", "foobar") do |filepath|
          expect(filepath).to eq(File.expand_path(File.join(Simpress::Config.output_dir, "test3.txt")))
        end
      end
    end
  end
end
