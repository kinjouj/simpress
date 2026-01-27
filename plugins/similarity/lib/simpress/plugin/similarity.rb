# frozen_string_literal: true

require "json"
require "zlib"
require "simpress/plugin"
require "simpress/writer"

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

      class CosineSimilarity
        HASH_BITS = 24
        BANDS     = 6

        attr_reader :keywords

        def initialize(posts)
          @keywords = []
          @size     = posts.size
          @data     = posts.map do |post|
            keywords = post.extract_keywords
            @keywords << keywords
            vector = keywords.tally
            post.categories.each {|category| vector[category.name] = (vector[category.name] || 0) + 50 }

            sum_of_squares = 0
            vector.each_value {|v| sum_of_squares += v * v }
            norm = Math.sqrt(sum_of_squares)

            { vector: vector, norm: norm, simhash: calculate_simhash(vector) }
          end
        end

        def each_similarity
          band_bits  = HASH_BITS / BANDS
          mask       = (1 << band_bits) - 1
          indices    = Array.new(@size) {|i| i }
          candidates = {}
          BANDS.times do |b|
            shift = b * band_bits
            indices.group_by {|i| (@data[i][:simhash] >> shift) & mask }.each_value do |ids|
              next if ids.size < 2

              ids.combination(2) do |i, j|
                i, j = j, i if i > j
                candidates[(i * @size) + j] = true
              end
            end
          end

          candidates.each_key do |key|
            i, j = key.divmod(@size)
            score = cosine(i, j)
            yield i, j, score if score > 0.1
          end
        end

        private

        def calculate_simhash(vector)
          v = Array.new(HASH_BITS, 0)
          vector.each do |word, weight|
            seed = Zlib.crc32(word)
            HASH_BITS.times {|bit| v[bit] += seed.anybits?(1 << bit) ? weight : -weight }
          end

          v.each_with_index.reduce(0) {|h, (val, i)| val.positive? ? h | (1 << i) : h }
        end

        def cosine(i, j)
          d1 = @data[i]
          d2 = @data[j]
          n1 = d1[:norm]
          n2 = d2[:norm]

          return 0.0 if n1.zero? || n2.zero?

          v1 = d1[:vector]
          v2 = d2[:vector]
          v1, v2 = v2, v1 if v1.size > v2.size

          product = 0.0
          v1.each {|k, v| product += v * v2.fetch(k, 0) }

          product / (n1 * n2)
        end
      end

      def self.run(posts, *_args)
        similarity_scores = Array.new(posts.size) { [] }
        cs = CosineSimilarity.new(posts)
        cs.each_similarity do |i, j, score|
          similarity_scores[i] << [score, j]
          similarity_scores[j] << [score, i]
        end

        similarity_scores.each_with_index do |scores, i|
          post = posts[i]
          similarities = scores.max_by(5, &:first).map do |_score, index|
            target = posts[index]
            # { id: target.id, title: target.title, permalink: target.permalink, keywords: cs.keywords[index].uniq }
            { id: target.id, title: target.title, permalink: target.permalink }
          end

          post.define_singleton_method(:similarities) { similarities || [] }
          post.define_singleton_method(:as_json) do |options = {}|
            hash = super(options)
            hash[:similarities] = similarities
            hash
          end
        end
      end
    end
  end
end
