# frozen_string_literal: true

require "simpress/config"
require "simpress/taxonomy/term"

module Simpress
  class Taxonomy
    DEFAULT_TAXONOMIES = ["categories"].freeze
    attr_reader :name, :terms

    def initialize(name)
      @name  = name
      @terms = {}
    end

    def term(name)
      @terms[name] ||= Simpress::Taxonomy::Term.new(name, key: self.class.slug_for(@name, name))
    end

    def self.fetch(name)
      (@cache ||= {})[name] ||= new(name)
    end

    def self.clear
      @cache&.clear
      @taxonomies = nil
    end

    def self.taxonomies
      @taxonomies ||= DEFAULT_TAXONOMIES.union(Simpress::Config.instance.taxonomies.keys).map {|name| fetch(name) }
    end

    def self.slug_for(taxonomy_name, term_name)
      Simpress::Config.instance.taxonomies.dig(taxonomy_name, term_name)
    end

    private_class_method :new
  end
end
