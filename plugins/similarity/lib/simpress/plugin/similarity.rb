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

        def initialize(posts)
          @size = posts.size
          @data = posts.map do |post|
            keywords = post.extract_keywords
            vector = keywords.tally
            post.categories.each {|category| vector[category.name] = (vector[category.name] || 0) + 50 }
            norm = Math.sqrt(vector.values.sum {|v| v * v })
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

          product = v1.sum(0.0) {|k, v| v * (v2[k] || 0) }
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
          similarity = scores.max_by(5, &:first).map do |score, index|
            target = posts[index]
            {
              score: score,
              id: target.id,
              title: target.title,
              permalink: target.permalink
            }
          end
          result = { title: post.title, similarity: similarity }

          Simpress::Writer.write("similarity/#{post.id}.json", result.to_json)
        end
      end
    end
  end
end
