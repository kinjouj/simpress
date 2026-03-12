# frozen_string_literal: true

require "natto"
require "xxhash"
require "simpress/plugin"

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

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
            [target.id, target.title, target.permalink]
          end

          post.define_singleton_method(:similarities) { similarities || [] }
          post.define_singleton_method(:as_json) do |state = {}|
            hash = super(state)
            hash[:similarities] = similarities if hash.key?(:content)
            hash
          end
        end
      end

      class CosineSimilarity
        NATTO_REGEX = /\A([^\t\n]{3,})\t名詞,(?:固有名詞|一般),[^\n]*\p{Han}/
        NATTO       = Natto::MeCab.new
        HASH_BITS   = 24
        BANDS       = 6

        def initialize(posts)
          @size       = posts.size
          @seed_cache = {}
          @data       = posts.map do |post|
            keywords = extract_keywords(post)
            vector = keywords.tally
            post.categories.each {|category| vector[category.name] = (vector[category.name] || 0) + 10 }

            sum_of_squares = vector.each_value.sum {|v| v * v }.to_f
            norm = Math.sqrt(sum_of_squares)

            { vector: vector, norm: norm, simhash: calculate_simhash(vector) }
          end
        end

        def each_similarity
          band_bits  = HASH_BITS / BANDS
          mask       = (1 << band_bits) - 1
          indices    = (0...@size).to_a
          candidates = Set.new
          BANDS.times do |b|
            shift = b * band_bits
            indices.group_by {|i| (@data[i][:simhash] >> shift) & mask }.each_value do |ids|
              next if ids.size < 2

              ids.combination(2) do |i, j|
                i, j = j, i if i > j
                key = (i * @size) + j
                next unless candidates.add?(key)

                score = cosine(i, j)
                yield i, j, score if score > 0.3
              end
            end
          end
        end

        private

        def extract_keywords(post)
          Cache.fetch("#{post.title} #{post.markdown}") do |data|
            keywords = {}
            NATTO.parse(data).each_line do |line|
              if line =~ NATTO_REGEX
                surface = Regexp.last_match(1)
                keywords[surface] ||= true
              end
            end

            keywords.keys
          end
        end

        def calculate_simhash(vector)
          v = Array.new(HASH_BITS, 0)
          vector.each do |word, weight|
            seed = (@seed_cache[word] ||= XXhash.xxh32(word))
            HASH_BITS.times {|bit| v[bit] += ((seed & (1 << bit)) == 0 ? -weight : weight) }
          end

          simhash = 0
          HASH_BITS.times {|i| simhash |= (1 << i) if v[i] > 0 }
          simhash
        end

        def cosine(i, j)
          d1 = @data[i]
          d2 = @data[j]
          n1 = d1[:norm]
          n2 = d2[:norm]

          return 0.0 if n1 == 0 || n2 == 0

          v1 = d1[:vector]
          v2 = d2[:vector]
          v1, v2 = v2, v1 if v1.size > v2.size

          product = 0.0
          v1.each do |k, v|
            w = v2[k]
            product += v * w if w
          end

          product / (n1 * n2)
        end

        class Cache
          def self.fetch(data)
            key  = XXhash.xxh32(data).to_s
            path = ".cache/#{key}.marshal"

            return Marshal.load(File.read(path)) if File.exist?(path)

            result = yield(data)
            File.write(path, Marshal.dump(result))
            result
          end
        end
      end
    end
  end
end
