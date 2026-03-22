# frozen_string_literal: true

module Simpress
  class Uri
    REGEX_EXT = /(?:\.[^.]+)?\Z/

    def initialize(path = "")
      @parts = [path]
      @ext = nil
    end

    def path(*others)
      others.each {|other| @parts << normalize(other) }
      self
    end

    def with_ext(ext)
      @ext = ext
      self
    end

    def build
      path = @parts.join("/")
      @ext ? path.sub(REGEX_EXT, ".#{@ext}") : path
    end

    def self.wrap(path)
      return path if path.is_a?(self)

      new(path)
    end

    private

    def normalize(path)
      path.to_s.delete_prefix("/")
    end
  end
end
