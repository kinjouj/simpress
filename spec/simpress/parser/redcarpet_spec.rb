# frozen_string_literal: true

require "simpress/config"
require "simpress/markdown/filter"
require "simpress/parser/redcarpet/renderer"
require "simpress/parser/redcarpet"

describe Simpress::Parser::Redcarpet do
  let(:data) { fixture("parser/redcarpet/parser_redcarpet_test.markdown").read }

  describe "#render" do
    it do
      body, images, tos = described_class.render(data)
      expect(body).not_to be_empty
      expect(images).to eq("/test1.jpg")
      expect(tos).to eq(["TEST1"])
    end
  end
end
