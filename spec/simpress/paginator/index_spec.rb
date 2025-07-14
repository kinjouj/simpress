# frozen_string_literal: true

require "simpress/paginator/index"

describe Simpress::Paginator::Index do
  context "最初のページからテスト" do
    it "successful" do
      paginator = Simpress::Paginator::Index.new(1, 5)
      expect(paginator.current_page).to eq("/index.html")
      expect(paginator.previous_page_exist?).to be_falsey
      expect(paginator.next_page_exist?).to be_truthy
      expect(paginator.next_page).to eq("/archives/page/2.html")
    end

    it "prefix値を変えてテスト" do
      paginator = Simpress::Paginator::Index.new(1, 10, "/archives/category/test")
      expect(paginator.current_page).to eq("/archives/category/test/index.html")
      expect(paginator.previous_page_exist?).to be_falsey
      expect(paginator.next_page_exist?).to be_truthy
      expect(paginator.next_page).to eq("/archives/category/test/2.html")
    end
  end

  context "page/maxpageを変えた場合" do
    it "2ページ目から検証" do
      paginator = Simpress::Paginator::Index.new(2, 10)
      expect(paginator.current_page).to eq("/archives/page/2.html")
      expect(paginator.previous_page_exist?).to be_truthy
      expect(paginator.previous_page).to eq("/")
      expect(paginator.next_page_exist?).to be_truthy
      expect(paginator.next_page).to eq("/archives/page/3.html")
    end

    it "最後のページからテスト" do
      paginator = Simpress::Paginator::Index.new(10, 10)
      expect(paginator.current_page).to eq("/archives/page/10.html")
      expect(paginator.previous_page_exist?).to be_truthy
      expect(paginator.previous_page).to eq("/archives/page/9.html")
      expect(paginator.next_page_exist?).to be_falsey
    end
  end

  context "引数の値チェック" do
    it "pageがpositiveではない場合" do
      expect { Simpress::Paginator::Index.new(0, 10) }.to raise_error(ArgumentError)
    end

    it "maxpageがpageよりも小さい場合" do
      expect { Simpress::Paginator::Index.new(1, 0)  }.to raise_error(ArgumentError)
    end

    it "前後のページがないのにも関わらずprevious_page/next_pageをコールした場合" do
      paginator = Simpress::Paginator::Index.new(1, 1)
      expect(paginator.previous_page_exist?).to be_falsey
      expect(paginator.next_page_exist?).to be_falsey
      expect { paginator.previous_page }.to raise_error("Not Found previous page")
      expect { paginator.next_page }.to raise_error("Not Found next page")
    end
  end
end
