# frozen_string_literal: true

require "simpress/paginator/post"

describe Simpress::Paginator::Post do
  # NOTE: [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  let(:data) { [*1..10].reverse }

  context "最初のポジションを指定した場合" do
    let(:paginator) { described_class.new(0, data) }

    it "前のページが存在し、前ページに遷移できること" do
      expect(paginator).to be_previous_page_exist
      expect(paginator.previous_page).to eq(9)
      expect(paginator).not_to be_next_page_exist
    end

    context "next_page_exist?がfalseなのにnext_pageをコールした場合" do
      it "エラーが発生すること" do
        expect(paginator).not_to be_next_page_exist
        expect { paginator.next_page }.to raise_error("Not Found next page")
      end
    end

    context "indexが許容を超えている場合" do
      it "ArgumentErrorが発生すること" do
        expect { described_class.new(data.size, data) }.to raise_error(ArgumentError)
      end
    end
  end

  context "indexが1の場合" do
    it "前後のページに正常に遷移できること" do
      paginator = described_class.new(1, data)
      expect(paginator).to be_previous_page_exist
      expect(paginator.previous_page).to eq(8)
      expect(paginator).to be_next_page_exist
      expect(paginator.next_page).to eq(10)
    end
  end

  context "最後のポジションからテストした場合" do
    let(:paginator) { described_class.new(data.size - 1, data) }

    it "次のページが存在し、次ページに遷移できること" do
      expect(paginator).not_to be_previous_page_exist
      expect(paginator).to be_next_page_exist
      expect(paginator.next_page).to eq(2)
    end

    context "previous_page_exist?がfalseなのにprevious_pageをコールした場合" do
      it "エラーが発生すること" do
        expect(paginator).not_to be_previous_page_exist
        expect { paginator.previous_page }.to raise_error("Not Found previous page")
      end
    end
  end
end
