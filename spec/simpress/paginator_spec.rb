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

    context "when prefix is given" do
      it "sets the custom prefix" do
        paginator = described_class.new(page: 1, maxpage: 5, prefix: "/custom")

        expect(paginator.prefix).to eq "/custom"
      end
    end

    context "when page is below 1" do
      it "raises ArgumentError" do
        expect { described_class.new(page: 0, maxpage: 5) }.to raise_error(/is out of range/)
      end
    end

    context "when page exceeds maxpage" do
      it "raises ArgumentError" do
        expect { described_class.new(page: 6, maxpage: 5) }.to raise_error(/is out of range/)
      end
    end
  end

  describe "#previous_page_exist?" do
    context "when not on first page" do
      it "returns true" do
        paginator = described_class.new(page: 2, maxpage: 2)

        expect(paginator.previous_page_exist?).to be true
      end
    end

    context "when on the first page" do
      it "returns false" do
        paginator = described_class.new(page: 1, maxpage: 2)

        expect(paginator.previous_page_exist?).to be false
      end
    end
  end

  describe "#next_page_exist?" do
    context "when not on last page" do
      it "returns true" do
        paginator = described_class.new(page: 1, maxpage: 2)

        expect(paginator.next_page_exist?).to be true
      end
    end

    context "when on the last page" do
      it "returns false" do
        paginator = described_class.new(page: 2, maxpage: 2)

        expect(paginator.next_page_exist?).to be false
      end
    end
  end

  describe "#previous_page" do
    context "when on page 2" do
      it "returns the root index" do
        paginator = described_class.new(page: 2, maxpage: 3, prefix: "/blog")

        expect(paginator.previous_page).to eq "/blog"
      end
    end

    context "when on page 3+" do
      it "returns that page path" do
        paginator = described_class.new(page: 3, maxpage: 5)

        expect(paginator.previous_page).to eq "/archives/page/2.html"
      end
    end

    context "when there's no previous page" do
      it "raises ArgumentError" do
        paginator = described_class.new(page: 1, maxpage: 5)

        expect { paginator.previous_page }.to raise_error("Not Found previous page")
      end
    end
  end

  describe "#next_page" do
    context "when a next page exists" do
      it "returns the next page path" do
        paginator = described_class.new(page: 1, maxpage: 5)

        expect(paginator.next_page).to eq "/archives/page/2.html"
      end
    end

    context "when there's no next page" do
      it "raises ArgumentError" do
        paginator = described_class.new(page: 5, maxpage: 5)

        expect { paginator.next_page }.to raise_error("Not Found next page")
      end
    end
  end

  describe "#current_page" do
    context "when on the first page" do
      it "returns index.html" do
        paginator = described_class.new(page: 1, maxpage: 5, prefix: "/blog")

        expect(paginator.current_page).to eq "/blog/index.html"
      end
    end

    context "when on page 2+" do
      it "returns that page path" do
        paginator = described_class.new(page: 2, maxpage: 5)

        expect(paginator.current_page).to eq "/archives/page/2.html"
      end
    end
  end
end
