# frozen_string_literal: true

require "simpress/paginator/post"

describe Simpress::Paginator::Post do
  # NOTE: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  let(:data) { [*1..10].reverse }

  context "最初のポジションを指定した場合" do
    let(:paginator) { described_class.new(0, data) }

    it "succesful" do
      expect(paginator).to be_previous_page_exist
      expect(paginator.previous_page).to eq(9)
      expect(paginator).not_to be_next_page_exist
    end

    it "next_page_exist?がfalseなのにnext_pageをコールした場合" do
      expect(paginator).not_to be_next_page_exist
      expect { paginator.next_page }.to raise_error("Not Found next page")
    end

    it "indexが許容を超えてる場合" do
      expect { described_class.new(data.size, data) }.to raise_error(ArgumentError)
    end
  end

  context "indexが1の場合" do
    it "successful" do
      paginator = described_class.new(1, data)
      expect(paginator).to be_previous_page_exist
      expect(paginator.previous_page).to eq(8)
      expect(paginator).to be_next_page_exist
      expect(paginator.next_page).to eq(10)
    end
  end

  context "最後のポジションからテスト" do
    let(:paginator) { described_class.new(data.size - 1, data) }

    it "successful" do
      expect(paginator).not_to be_previous_page_exist
      expect(paginator).to be_next_page_exist
      expect(paginator.next_page).to eq(2)
    end

    it "previous_page_exist?がfalseなのにprevious_pageをコールした場合" do
      expect(paginator).not_to be_previous_page_exist
      expect { paginator.previous_page }.to raise_error("Not Found previous page")
    end
  end
end
