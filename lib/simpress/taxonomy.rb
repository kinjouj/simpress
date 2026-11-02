# frozen_string_literal: true

require "simpress/config"
require "simpress/taxonomy/term"

module Simpress
  class Taxonomy
    DEFAULT_TAXONOMIES = ["categories", "tags"].freeze

    attr_reader :name

    class << self
      def fetch(name)
        (@cache ||= {})[name] ||= new(name)
      end

      def clear
        @cache&.clear
        @taxonomies = nil
      end

      def taxonomies
        @taxonomies ||= DEFAULT_TAXONOMIES.union(Simpress::Config.taxonomies[:types] || []).map {|name| fetch(name) }
      end

      def resolve(params)
        taxonomies.to_h do |taxonomy|
          names = Array(params[taxonomy.name.to_sym]).uniq
          [taxonomy.name, names.map {|name| taxonomy.term(name) }]
        end
      end

      def register(taxonomies, entry)
        taxonomies.each_value {|terms| terms.each {|term| term.entries << entry } }
      end
    end

    def initialize(name)
      @name = name
      @terms = {}
    end

    def terms
      @terms.select {|_, term| term.entries.any? }
    end

    def term(name)
      @terms[name] ||= Simpress::Taxonomy::Term.new(name, key: Simpress::Config.taxonomies.dig(:aliases, @name.to_sym, name.to_s.to_sym))
    end

    private_class_method :new
  end
end
