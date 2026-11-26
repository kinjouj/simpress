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
      let(:source) do
        build(:entry, permalink: "/source.html", content: +"<p>Before</p><!--link-card:/target.html--><p>After</p>")
      end

      it "replaces with a card" do
        described_class.run([source, target])

        expect(source.content).to include(
          "<p>Before</p>",
          "<p>After</p>",
          '<a href="/target.html">',
          '<img src="/images/target.webp" />Target Title</a>Target description</div>'
        )
        expect(source.content).not_to include("<!--link-card")
      end
    end

    context "when multiple markers exist" do
      let(:other) do
        build(:entry, permalink: "/other.html", title: "Other Title", content: +"<p>Other body</p>")
      end

      let(:source1) do
        build(:entry, permalink: "/source1.html", content: +"<!--link-card:/target.html--><!--link-card:/other.html-->")
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

        expect(source1.content).to include("Target Title</a>", "Other Title</a>")
        expect(source2.content).to include("Target Title</a>")
        expect([source1, source2].map(&:content).join).not_to include("<!--link-card")
      end
    end

    context "when linked entry doesn't exist" do
      let(:source) do
        build(:entry, permalink: "/source.html", content: +"<!--link-card:/missing.html-->")
      end

      it "doesn't replace" do
        expect { described_class.run([source, target]) }.not_to change(source, :content)
      end
    end

    context "when the entry lacks markers" do
      let(:source) do
        build(:entry, permalink: "/source.html", content: +"<p>Body</p>")
      end

      it "doesn't change the content" do
        expect { described_class.run([source, target]) }.not_to change(source, :content)
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

        expect(source.content).to include('<a href="/hyphen-">', "Hyphen Title</a>")
        expect(source.content).not_to include("<!--link-card")
      end
    end
  end

  describe Simpress::Plugin::LinkCard::Filter do
    describe ".preprocess" do
      context "when a standalone link" do
        let(:markdown) do
          <<~MARKDOWN
            Text before

            @[](/first.html)
            @[](/second/page.html)

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
          expect(described_class.preprocess(markdown)).to eq expected
        end
      end

      context "when not a conversion target" do
        context "when the @ is missing" do
          it "doesn't convert" do
            data = "[](/plain.html)"
            expect(described_class.preprocess(data.dup)).to eq data
          end
        end

        context "when the link has label" do
          it "doesn't convert" do
            data = "@[Label](/label.html)"
            expect(described_class.preprocess(data.dup)).to eq data
          end
        end

        context "when an external URL" do
          it "doesn't convert" do
            data = "@[](https://example.com/page.html)"
            expect(described_class.preprocess(data.dup)).to eq data
          end
        end

        context "when text precedes link" do
          it "doesn't convert" do
            data = "abc@[](/inline.html)"
            expect(described_class.preprocess(data.dup)).to eq data
          end
        end

        context "when text follows link" do
          it "doesn't convert" do
            data = "@[](/inline.html)abc"
            expect(described_class.preprocess(data.dup)).to eq data
          end
        end

        context "when path contains a space" do
          it "doesn't convert" do
            data = "@[](/with space.html)"
            expect(described_class.preprocess(data.dup)).to eq data
          end
        end
      end
    end
  end
end
