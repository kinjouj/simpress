# frozen_string_literal: true

require "simpress/plugin"
require "simpress/parser/markdown/filter"

module Simpress
  module Plugin
    class LinkCard
      extend Simpress::Plugin

      MARKER_REGEX = %r{<!--link-card:(/\S*?)-->}

      class Filter
        extend Simpress::Parser::Markdown::Filter

        LINK_REGEX = %r{^\[\]\((/[^)\s"]*)\)$}

        def self.preprocess(markdown)
          markdown.gsub(LINK_REGEX, %(<!--link-card:\\1-->))
        end
      end

      def self.run(entries)
        index = entries.to_h {|entry| [entry.permalink, entry] }
        entries.each do |entry|
          entry.content.gsub!(MARKER_REGEX) do |marker|
            target = index[Regexp.last_match(1)]
            target ? build_card(target) : marker
          end
        end
      end

      def self.build_card(entry)
        %(<div class="link-card"><a href="#{entry.permalink}"><img src="#{entry.cover}" alt="" /><span>#{entry.title}</span></a><span>#{entry.description}</span></div>)
      end

      private_class_method :build_card
    end
  end
end
