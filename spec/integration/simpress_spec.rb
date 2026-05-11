# frozen_string_literal: true

require "simpress"

def create_filepath(path)
  File.expand_path(path, __dir__)
end

describe Simpress do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Logger).to receive(:debug)
    allow(Simpress::Config).to receive(:source_dir).and_return(create_filepath("source"))
    allow(Simpress::Config).to receive(:theme_dir).and_return(create_filepath("theme"))
    allow(Simpress::Config).to receive(:output_dir).and_return(create_filepath("public"))
    allow(Simpress::Config).to receive(:plugin_dir).and_return(create_filepath("plugins"))
    allow(Simpress::Config.instance).to receive(:mode).and_return("html")
    allow(Simpress::Config.instance).to receive(:plugins).and_return(["main_test"])
    allow(Simpress::Config.instance).to receive(:paginate).and_return(1)
  end

  after do
    Dir.glob(create_filepath("public/*")) {|file| FileUtils.rm_rf(file) }
    Simpress::Taxonomy.clear
  end

  it "builds the site and generates all expected output files" do
    described_class.build
    expect(Simpress::Logger).to have_received(:info).at_least(1).times
    expect(Simpress::Logger).to have_received(:debug).exactly(1).times
    expect(File).to exist(create_filepath("public/count.txt"))
    expect(File).to exist(create_filepath("public/test.html"))
    expect(File).to exist(create_filepath("public/test2.html"))
    expect(File).to exist(create_filepath("public/index.html"))
    expect(File).to exist(create_filepath("public/archives/page/2.html"))
    expect(File).to exist(create_filepath("public/archives/2000/01/index.html"))
    expect(File).to exist(create_filepath("public/archives/2000/01/2.html"))
    expect(File).to exist(create_filepath("public/archives/categories/test/index.html"))
    expect(File).to exist(create_filepath("public/archives/categories/test/2.html"))
  end
end
