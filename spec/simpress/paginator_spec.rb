# frozen_string_literal: true

require "simpress/paginator"

describe Simpress::Paginator do
  describe "#initialize" do
    it "pageとmaxpageを設定する" do
      paginator = described_class.new(page: 1, maxpage: 5)

      expect(paginator.page).to eq 1
      expect(paginator.maxpage).to eq 5
      expect(paginator.prefix).to eq "/archives/page"
    end

    context "prefixが指定された場合" do
      it "カスタムprefixを設定する" do
        paginator = described_class.new(page: 1, maxpage: 5, prefix: "/custom")

        expect(paginator.prefix).to eq "/custom"
      end
    end

    context "pageが0以下の場合" do
      it "ArgumentErrorを発生させる" do
        expect { described_class.new(page: 0, maxpage: 5) }.to raise_error(/is out of range/)
      end
    end

    context "pageがmaxpageを超える場合" do
      it "ArgumentErrorを発生させる" do
        expect { described_class.new(page: 6, maxpage: 5) }.to raise_error(/is out of range/)
      end
    end
  end

  describe "#previous_page_exist?" do
    context "最初のページではない場合" do
      it "trueを返す" do
        paginator = described_class.new(page: 2, maxpage: 2)

        expect(paginator.previous_page_exist?).to be true
      end
    end

    context "最初のページの場合" do
      it "falseを返す" do
        paginator = described_class.new(page: 1, maxpage: 2)

        expect(paginator.previous_page_exist?).to be false
      end
    end
  end

  describe "#next_page_exist?" do
    context "最後のページではない場合" do
      it "trueを返す" do
        paginator = described_class.new(page: 1, maxpage: 2)

        expect(paginator.next_page_exist?).to be true
      end
    end

    context "最後のページの場合" do
      it "falseを返す" do
        paginator = described_class.new(page: 2, maxpage: 2)

        expect(paginator.next_page_exist?).to be false
      end
    end
  end

  describe "#previous_page" do
    context "2ページ目の場合" do
      it "ルートのindexを返す" do
        paginator = described_class.new(page: 2, maxpage: 3, prefix: "/blog")

        expect(paginator.previous_page).to eq "/blog"
      end
    end

    context "3ページ目以降の場合" do
      it "該当ページのパスを返す" do
        paginator = described_class.new(page: 3, maxpage: 5)

        expect(paginator.previous_page).to eq "/archives/page/2.html"
      end
    end

    context "前のページが存在しない場合" do
      it "ArgumentErrorを発生させる" do
        paginator = described_class.new(page: 1, maxpage: 5)

        expect { paginator.previous_page }.to raise_error("Not Found previous page")
      end
    end
  end

  describe "#next_page" do
    context "次のページが存在する場合" do
      it "次のページのパスを返す" do
        paginator = described_class.new(page: 1, maxpage: 5)

        expect(paginator.next_page).to eq "/archives/page/2.html"
      end
    end

    context "次のページが存在しない場合" do
      it "ArgumentErrorを発生させる" do
        paginator = described_class.new(page: 5, maxpage: 5)

        expect { paginator.next_page }.to raise_error("Not Found next page")
      end
    end
  end

  describe "#current_page" do
    context "最初のページの場合" do
      it "index.htmlを返す" do
        paginator = described_class.new(page: 1, maxpage: 5, prefix: "/blog")

        expect(paginator.current_page).to eq "/blog/index.html"
      end
    end

    context "2ページ目以降の場合" do
      it "該当ページのパスを返す" do
        paginator = described_class.new(page: 2, maxpage: 5)

        expect(paginator.current_page).to eq "/archives/page/2.html"
      end
    end
  end
end
