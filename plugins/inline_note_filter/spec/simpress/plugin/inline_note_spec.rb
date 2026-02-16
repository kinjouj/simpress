# frozen_string_literal: true

require "simpress/plugin/inline_note"

describe Simpress::Plugin::InlineNote do
  describe "#preprocess" do
    it "正常に変換されること" do
      markdown = <<~MARKDOWN
        [^]: Hello World
      MARKDOWN

      res = described_class.preprocess(markdown)
      expect(res).to eq(%(<div class="note"><i class="fa-solid fa-circle-exclamation"></i>Hello World</div>\n))
    end

    it "[^]:のあとにスペースがなくても問題ないこと" do
      markdown = <<~MARKDOWN
        [^]:Hello World
      MARKDOWN

      res = described_class.preprocess(markdown)
      expect(res).to eq(%(<div class="note"><i class="fa-solid fa-circle-exclamation"></i>Hello World</div>\n))
    end
  end
end
