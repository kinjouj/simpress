# frozen_string_literal: true

require "simpress/config"
require "simpress/taxonomy/term"

module Simpress
  class Taxonomy
    DEFAULT_TAXONOMIES = ["categories", "tags"].freeze

    attr_reader :name

    def self.fetch(name)
      (@cache ||= {})[name] ||= new(name)
    end

    def self.clear
      @cache&.clear
      @taxonomies = nil
    end

    def self.taxonomies
      @taxonomies ||= DEFAULT_TAXONOMIES.union(Simpress::Config.instance.taxonomies["types"] || []).map {|name| fetch(name) }
    end

    def self.resolve(params)
      taxonomies.to_h {|taxonomy| [taxonomy.name, Array(params[taxonomy.name.to_sym]).map {|name| taxonomy.term(name) }] }
    end

    def self.register(taxonomies, entry)
      taxonomies.each_value {|terms| terms.each {|term| term.entries << entry } }
    end

    def initialize(name)
      @name = name
      @terms = {}
    end

    def terms
      @terms.select {|_, term| term.entries.any? }
    end

    def term(name)
      @terms[name] ||= Simpress::Taxonomy::Term.new(name, key: Simpress::Config.instance.taxonomies.dig("aliases", @name, name))
    end

    private_class_method :new
  end
end
