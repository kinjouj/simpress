# frozen_string_literal: true

require "simpress/plugin/link_card"

describe Simpress::Plugin::LinkCard do
  describe ".run" do
    let(:target) do
      build(
        :entry,
        permalink: "/target.html",
        title: "Target Title",
        description: "Target description",
        cover: "/images/target.webp",
        content: +"<p>Target body</p>"
      )
    end

    context "when the linked entry exists" do
      let(:content) do
        <<~HTML
          <p>Before</p>
          <!--link-card:/target.html-->
          <p>After</p>
        HTML
      end

      let(:source) do
        build(:entry, permalink: "/source.html", content: content.dup)
      end

      it "replaces with a card" do
        described_class.run([source, target])

        expect(source.content).to include(
          "<p>Before</p>",
          "<p>After</p>",
          '<a href="/target.html">',
          '<img src="/images/target.webp" alt="" />',
          "<span>Target Title</span>",
          "<span>Target description</span>"
        )
        expect(source.content).not_to include("<!--link-card")
      end
    end

    context "when multiple markers exist" do
      let(:other) do
        build(:entry, permalink: "/other.html", title: "Other Title", content: +"<p>Other body</p>")
      end

      let(:content1) do
        <<~HTML
          <!--link-card:/target.html-->
          <!--link-card:/other.html-->
        HTML
      end

      let(:source1) do
        build(:entry, permalink: "/source1.html", content: content1.dup)
      end

      let(:source2) do
        build(
          :entry,
          permalink: "/source2.html",
          content: +"<!--link-card:/target.html-->"
        )
      end

      it "replaces each with a card" do
        described_class.run([source1, source2, target, other])

        expect(source1.content).to include("<span>Target Title</span>", "<span>Other Title</span>")
        expect(source2.content).to include("<span>Target Title</span>")
        expect([source1, source2].map(&:content).join).not_to include("<!--link-card")
      end
    end

    context "when linked entry doesn't exist" do
      let(:content) do
        <<~HTML
          <p>Before</p>
          <!--link-card:/missing.html-->
          <p>After</p>
        HTML
      end

      let(:source) do
        build(:entry, permalink: "/source.html", content: content.dup)
      end

      it "doesn't replace" do
        described_class.run([source, target])

        expect(source.content).to eq content
      end
    end

    context "when the entry lacks markers" do
      let(:source) do
        build(:entry, permalink: "/source.html", content: +"<p>Body</p>")
      end

      it "doesn't change the content" do
        described_class.run([source, target])

        expect(source.content).to eq "<p>Body</p>"
      end
    end

    context "when permalink ends with hyphen" do
      let(:hyphen) do
        build(:entry, permalink: "/hyphen-", title: "Hyphen Title", content: +"<p>Body</p>")
      end

      let(:source) do
        build(:entry, permalink: "/source.html", content: +"<!--link-card:/hyphen--->")
      end

      it "replaces with a card" do
        described_class.run([source, hyphen])

        expect(source.content).to include('<a href="/hyphen-">', "<span>Hyphen Title</span>")
        expect(source.content).not_to include("<!--link-card")
      end
    end
  end

  describe "Filter.preprocess" do
    subject(:filter) do
      described_class::Filter
    end

    context "when a standalone link" do
      let(:markdown) do
        <<~MARKDOWN
          Text before

          [](/first.html)
          [](/second/page.html)

          Text after
        MARKDOWN
      end

      let(:expected) do
        <<~MARKDOWN
          Text before

          <!--link-card:/first.html-->
          <!--link-card:/second/page.html-->

          Text after
        MARKDOWN
      end

      it "converts to a marker" do
        expect(filter.preprocess(markdown)).to eq expected
      end
    end

    context "when not a conversion target" do
      context "when the link has label" do
        it "doesn't convert" do
          data = "[Label](/label.html)"
          expect(filter.preprocess(data)).to eq data
        end
      end

      context "when an external URL" do
        it "doesn't convert" do
          data = "[](https://example.com/page.html)"
          expect(filter.preprocess(data)).to eq data
        end
      end

      context "when text precedes link" do
        it "doesn't convert" do
          data = "abc[](/inline.html)"
          expect(filter.preprocess(data)).to eq data
        end
      end

      context "when text follows link" do
        it "doesn't convert" do
          data = "[](/inline.html)abc"
          expect(filter.preprocess(data)).to eq data
        end
      end

      context "when path contains a space" do
        it "doesn't convert" do
          data = "[](/with space.html)"
          expect(filter.preprocess(data)).to eq data
        end
      end
    end
  end
end
