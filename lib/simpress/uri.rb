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
      parts = [@base, *@parts]

      if @ext
        last = parts.last
        dot_idx = last.rindex(".")
        parts[-1] = dot_idx ? "#{last[0...dot_idx]}.#{@ext}" : "#{last}.#{@ext}"
      end

      parts.join("/")
    end

    def to_s
      build
    end

    def self.wrap(path)
      return path if path.is_a?(self)

      new(path)
    end
  end
end
