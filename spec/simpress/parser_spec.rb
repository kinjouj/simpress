# frozen_string_literal: true

require "simpress/parser"

describe Simpress::Parser do
  let(:file) do
    "2026-01-01-test-entry.md"
  end

  let(:markdown) do
    <<~MD
      ---
      title: Test Title
      date: 2026-01-01
      permalink: /2026/01/test-entry
      ---
      This is the description.

      This is the content.
    MD
  end

  let(:body) do
    <<~MD
      This is the description.

      This is the content.
    MD
  end

  let(:html) do
    <<~HTML
      <p>This is the description.</p>
      <p>This is the content.</p>
    HTML
  end

  before do
    allow(File).to receive(:read).and_return(markdown)
    allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(Simpress::Parser::Markdown::Processor::Result.new(html, "cover.jpg", []))
    allow(XXhash).to receive(:xxh64).and_return(999)
  end

  describe ".parse" do
    it "returns an entry" do
      entry = described_class.parse(file)

      expect(entry.id).to eq "999"
      expect(entry.title).to eq "Test Title"
      expect(entry.date).to eq Time.new(2026, 1, 1)
      expect(entry.permalink).to eq "/2026/01/test-entry"
      expect(entry.content).to eq html
      expect(entry.toc).to eq []
      expect(entry.description).to eq "This is the description."
      expect(entry.cover).to eq "cover.jpg"
      expect(Simpress::Parser::Markdown::Processor).to have_received(:render).with(body)
    end

    context "when custom keys are given" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-entry
          og_image: /images/og.png
          ---
          body
        MD
      end

      it "exposes custom keys in params" do
        entry = described_class.parse(file)

        expect(entry.params[:og_image]).to eq "/images/og.png"
        expect(entry.params[:title]).to eq "Test Title"
      end
    end

    context "when cover and description set" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          permalink: /2026/01/test-entry
          cover: front.png
          description: Front description
          ---
          body
        MD
      end

      it "prefers front matter values" do
        entry = described_class.parse(file)

        expect(entry.cover).to eq "front.png"
        expect(entry.description).to eq "Front description"
      end
    end

    context "when cover and description unset" do
      before do
        allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(
          Simpress::Parser::Markdown::Processor::Result.new("<p>Hello <strong>world</strong>!</p>", nil, [])
        )
      end

      it "falls back to defaults" do
        entry = described_class.parse(file)

        expect(entry.cover).to eq described_class::DEFAULT_COVER
        expect(entry.description).to eq "This is the description."
      end
    end

    context "when front matter sets draft" do
      let(:markdown) do
        <<~MD
          ---
          title: Draft Title
          date: 2026-01-01
          draft: true
          ---
          body
        MD
      end

      it "doesn't render the Markdown" do
        entry = described_class.parse(file)

        expect(entry.draft).to be true
        expect(entry.content).to be_nil
        expect(Simpress::Parser::Markdown::Processor).not_to have_received(:render)
      end
    end

    context "when date is missing" do
      context "when file name lacks date" do
        let(:markdown) do
          <<~MD
            ---
            title: No Date
            permalink: /no-date
            ---
            body
          MD
        end

        it "sets date nil, index false" do
          entry = described_class.parse("no-date.md")

          expect(entry.date).to be_nil
          expect(entry.index).to be false
        end
      end

      context "when file name has date" do
        let(:markdown) do
          <<~MD
            ---
            title: From Filename
            ---
            body
          MD
        end

        it "sets date nil, index false" do
          entry = described_class.parse("2026-01-01-from-filename.md")

          expect(entry.date).to be_nil
          expect(entry.index).to be false
        end
      end
    end

    context "when front matter has categories" do
      let(:markdown) do
        <<~MD
          ---
          title: Test Title
          date: 2026-01-01
          permalink: /2026/01/test-entry
          categories: Ruby
          ---
          body
        MD
      end

      before do
        allow(Simpress::Config).to receive(:taxonomies).and_return({ aliases: { categories: { Ruby: "ruby" } } })
      end

      after do
        Simpress::Taxonomy.clear
      end

      it "has the taxonomies terms" do
        entry = described_class.parse(file)

        expect(entry.taxonomies["categories"].map(&:name)).to eq ["Ruby"]
        expect(entry.taxonomies["categories"].first.entries).not_to include(entry)
      end

      context "when index is false" do
        let(:markdown) do
          <<~MD
            ---
            title: Hidden
            date: 2026-01-02
            index: false
            categories: Ruby
            ---
            body
          MD
        end

        it "has no taxonomies" do
          entry = described_class.parse(file)

          expect(entry.taxonomies.values).to all(eq [])
        end
      end

      context "when date isn't set" do
        let(:markdown) do
          <<~MD
            ---
            title: No Date
            permalink: /no-date
            categories: Ruby
            ---
            body
          MD
        end

        it "has no taxonomies" do
          entry = described_class.parse(file)

          expect(entry.taxonomies.values).to all(eq [])
        end
      end
    end

    context "when permalink is missing" do
      context "when file is in subdirectory" do
        let(:markdown) do
          <<~MD
            ---
            title: About
            date: 2026-01-01
            ---
            body
          MD
        end

        it "builds from directory and basename" do
          expect(described_class.parse("source/company/about.markdown").permalink).to eq "/company/about"
        end
      end

      context "when file is under source" do
        let(:markdown) do
          <<~MD
            ---
            title: Contact
            ---
            body
          MD
        end

        it "builds permalink from basename" do
          expect(described_class.parse("source/contact.markdown").permalink).to eq "/contact"
        end
      end
    end

    context "when permalink is given" do
      context "when file is under source" do
        let(:markdown) do
          <<~MD
            ---
            title: Test Title
            permalink: /existing/path
            ---
          MD
        end

        it "uses that permalink" do
          expect(described_class.parse(file).permalink).to eq "/existing/path"
        end
      end

      context "when there's a leading slash" do
        let(:markdown) do
          <<~MD
            ---
            title: About
            permalink: /team
            ---
            body
          MD
        end

        it "places under file directory" do
          expect(described_class.parse("source/company/about.markdown").permalink).to eq "/company/team"
        end
      end

      context "when there's no leading slash" do
        let(:markdown) do
          <<~MD
            ---
            title: Staff
            permalink: staff/list
            ---
            body
          MD
        end

        it "places under file directory" do
          expect(described_class.parse("source/company/staff.markdown").permalink).to eq "/company/staff/list"
        end
      end
    end

    context "when date is given" do
      context "when a Time string" do
        let(:markdown) do
          <<~MD
            ---
            title: Test Title
            permalink: /2026/01/test-entry
            date: 2025-01-01 00:00:00
            ---
          MD
        end

        it "parses into Time" do
          expect(described_class.parse(file).date).to be_a(Time)
        end
      end

      context "when a Date" do
        let(:markdown) do
          <<~MD
            ---
            title: Test Title
            permalink: /2026/01/test-entry
            date: 2025-01-01
            ---
          MD
        end

        it "parses into Time" do
          expect(described_class.parse(file).date).to be_a(Time)
        end
      end

      context "when a String" do
        let(:markdown) do
          <<~MD
            ---
            title: Test Title
            permalink: /2026/01/test-entry
            date: "2025-01-01"
            ---
          MD
        end

        it "parses into Time" do
          expect(described_class.parse(file).date).to be_a(Time)
        end
      end
    end
  end
end
