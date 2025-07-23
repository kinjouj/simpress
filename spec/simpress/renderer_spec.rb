# frozen_string_literal: true

require "simpress/config"
require "simpress/renderer"
require "simpress/renderer/html"

describe Simpress::Renderer do
  it do
    allow(Simpress::Renderer::Html).to receive(:generate).with([], [], [])
    Simpress::Renderer.generate([], [], [])
  end
end
