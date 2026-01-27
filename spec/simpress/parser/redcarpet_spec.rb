# frozen_string_literal: true

require "simpress/parser/redcarpet"

describe Simpress::Parser::Redcarpet do
  it "markdownをrenderすると正しくbody、images、tosが返されること" do
    markdown = <<~MARKDOWN
      #### TEST1

      ![](/test1.jpg)

      ![](/test2.jpg)

      ### TEST2
    MARKDOWN
    body, images, tos = described_class.render(markdown)
    expect(body).not_to be_empty
    expect(images).to eq("/test1.jpg")
    expect(tos).to match([[anything, "TEST1"]])
  end
end
