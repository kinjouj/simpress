# frozen_string_literal: true

module Simpress
  class Uri
    def initialize(path = "")
      @base  = path
      @parts = []
      @ext = nil
    end

    def path(*others)
      @parts = others.map {|other| other.to_s.delete_prefix("/") }
      self
    end

    def with_ext(ext)
      @ext = ext
      self
    end

    def build
      path = [@base, *@parts].join("/")
      @ext ? "#{path[0...(path.rindex('.'))]}.#{@ext}" : path
    end

    def self.wrap(path)
      return path if path.is_a?(self)

      new(path)
    end
  end
end
