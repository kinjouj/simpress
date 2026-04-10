# frozen_string_literal: true

require "simpress/paginator"

describe Simpress::Paginator do
  describe "#initialize" do
    it "sets page and maxpage" do
      paginator = described_class.new(page: 1, maxpage: 5)
      expect(paginator.page).to eq 1
      expect(paginator.maxpage).to eq 5
      expect(paginator.prefix).to eq "/archives/page"
    end

    it "sets custom prefix when provided" do
      paginator = described_class.new(page: 1, maxpage: 5, prefix: "/custom")
      expect(paginator.prefix).to eq "/custom"
    end

    it "raises ArgumentError when page is 0 or less" do
      expect { described_class.new(page: 0, maxpage: 5) }.to raise_error(ArgumentError, /is out of range/)
    end

    it "raises ArgumentError when page exceeds maxpage" do
      expect { described_class.new(page: 6, maxpage: 5) }.to raise_error(ArgumentError, /is out of range/)
    end
  end

  describe "#previous_page_exist?" do
    it "returns true if not on the first page" do
      paginator = described_class.new(page: 2, maxpage: 2)
      expect(paginator.previous_page_exist?).to be true
    end

    it "returns false if on the first page" do
      paginator = described_class.new(page: 1, maxpage: 2)
      expect(paginator.previous_page_exist?).to be false
    end
  end

  describe "#next_page_exist?" do
    it "returns true if not on the last page" do
      paginator = described_class.new(page: 1, maxpage: 2)
      expect(paginator.next_page_exist?).to be true
    end

    it "returns false if on the last page" do
      paginator = described_class.new(page: 2, maxpage: 2)
      expect(paginator.next_page_exist?).to be false
    end
  end

  describe "#previous_page" do
    it "returns root index for the second page" do
      paginator = described_class.new(page: 2, maxpage: 3, prefix: "/blog")
      expect(paginator.previous_page).to eq "/blog"
    end

    it "returns the specific page path for page 3 or later" do
      paginator = described_class.new(page: 3, maxpage: 5)
      expect(paginator.previous_page).to eq "/archives/page/2.html"
    end

    it "raises error when previous page does not exist" do
      paginator = described_class.new(page: 1, maxpage: 5)
      expect { paginator.previous_page }.to raise_error("Not Found previous page")
    end
  end

  describe "#next_page" do
    it "returns the next page path" do
      paginator = described_class.new(page: 1, maxpage: 5)
      expect(paginator.next_page).to eq "/archives/page/2.html"
    end

    it "raises error when next page does not exist" do
      paginator = described_class.new(page: 5, maxpage: 5)
      expect { paginator.next_page }.to raise_error("Not Found next page")
    end
  end

  describe "#current_page" do
    it "returns index.html for the first page" do
      paginator = described_class.new(page: 1, maxpage: 5, prefix: "/blog")
      expect(paginator.current_page).to eq "/blog/index.html"
    end

    it "returns specific page path for page 2 or later" do
      paginator = described_class.new(page: 2, maxpage: 5)
      expect(paginator.current_page).to eq "/archives/page/2.html"
    end
  end
end
