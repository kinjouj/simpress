# frozen_string_literal: true

require "simpress/parser/redcarpet/filter/inline_note"

describe Simpress::Parser::Redcarpet::Filter::InlineNote do
  describe "#preprocess" do
    it "successful" do
      markdown = <<MARKDOWN
[^]: Hello World
MARKDOWN

      res = Simpress::Parser::Redcarpet::Filter::InlineNote.preprocess(markdown)
      expect(res).to eq(%(<div class="note"><span class="material-symbols-outlined">info</span>Hello World</div>))
    end

    it "[^]:のあとにスペースがなくても問題ないこと" do
      markdown = <<MARKDOWN
[^]:Hello World
MARKDOWN

      res = Simpress::Parser::Redcarpet::Filter::InlineNote.preprocess(markdown)
      expect(res).to eq(%(<div class="note"><span class="material-symbols-outlined">info</span>Hello World</div>))
    end
  end
end
