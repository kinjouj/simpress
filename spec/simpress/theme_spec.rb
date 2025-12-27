# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

describe Simpress::Theme do
  before do
    allow(described_class).to receive(:theme_dir).and_return(fixture("theme").path)
  end

  it :create_erubis do
    create_erubis = ->(template) { described_class.send(:create_erubis, template) }

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

    allow(File).to receive(:read) {
      raise RuntimeError
    }
    expect { create_erubis.call("post") }.to raise_error(RuntimeError)
  end

  it :render do
    data = described_class.render("post", { post: { title: "test" } })
    expect(data).not_to be_empty
  end

  describe "#exist?" do
    it "successful" do
      expect(described_class).to exist("post")
      expect(described_class).not_to exist("test")
    end
  end
end
