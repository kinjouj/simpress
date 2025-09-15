# frozen_string_literal: true

require "simpress/config"
require "simpress/writer"

describe Simpress::Writer do
  before do
    allow(described_class).to receive(:output_dir).and_return(create_filepath("../tmp"))
  end

  after do
    Dir[create_filepath("../tmp/*.txt")].each {|file| FileUtils.rm_rf(file) }
  end

  describe "#write" do
    it "successful" do
      described_class.write("./test.txt", "hoge")
      expect(File).to exist(create_filepath("../tmp/test.txt"))
    end

    it "既に存在するファイルに書き込みしようとした場合" do
      described_class.write("./test2.txt", "hoge")
      expect { described_class.write("./test2.txt", "fuga") }.to raise_error(RuntimeError)
    end

    it "blockを要求した場合" do
      described_class.write("./test3.txt", "foobar") do |filepath|
        expect(filepath).to eq(create_filepath("../tmp/test3.txt"))
      end
    end
  end
end
