# frozen_string_literal: true

require "simpress/config"
require "simpress/renderer"
require "simpress/renderer/html"

describe Simpress::Renderer do
  before do
    stub_const("Simpress::Config::CONFIG_FILE", fixture("test_config.yaml").path)
    Simpress::Config.clear
  end

  it "test" do # rubocop:disable RSpec/NoExpectationExample
    allow(Simpress::Renderer::Html).to receive(:generate).with([], [], [])
    described_class.generate([], [], [])
  end
end
