# frozen_string_literal: true

require "json"
require "natto"
require "xxhash"
require "simpress/plugin"
require "simpress/writer"

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

      class CosineSimilarity
        NATTO_REGEX = /\A([^\t\n]{3,})\t名詞,(?:固有名詞|一般),[^\n]*?\p{Han}/
        NATTO       = Natto::MeCab.new
        HASH_BITS   = 12
        BANDS       = 3

        attr_reader :keywords

        def initialize(posts)
          @keywords = []
          @size     = posts.size
          @data     = posts.map do |post|
            keywords = extract_keywords(post)
            @keywords << keywords
            vector = keywords.tally
            post.categories.each {|category| vector[category.name] = (vector[category.name] || 0) + 50 }

            sum_of_squares = vector.each_value.sum {|v| v * v }.to_f
            norm = Math.sqrt(sum_of_squares)

            { vector: vector, norm: norm, simhash: calculate_simhash(vector) }
          end
        end

        def each_similarity
          band_bits  = HASH_BITS / BANDS
          mask       = (1 << band_bits) - 1
          indices    = (0...@size).to_a
          candidates = {}
          BANDS.times do |b|
            shift = b * band_bits
            indices.group_by {|i| (@data[i][:simhash] >> shift) & mask }.each_value do |ids|
              next if ids.size < 2

              ids.combination(2) do |i, j|
                i, j = j, i if i > j
                key = (i * @size) + j
                next if candidates[key]

                candidates[key] = true
                score = cosine(i, j)
                yield i, j, score if score > 0.3
              end
            end
          end
        end

        private

        def extract_keywords(post)
          keywords = {}
          text     = "#{post.title}\n#{post.markdown}"
          NATTO.parse(text).each_line do |line|
            if line =~ NATTO_REGEX
              surface = Regexp.last_match(1)
              keywords[surface] ||= true
            end
          end

          keywords.keys
        end

        def calculate_simhash(vector)
          v = Array.new(HASH_BITS, 0)
          vector.each do |word, weight|
            seed = XXhash.xxh32(word)
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
          v1.each {|k, v| product += v * (v2[k] || 0) }
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

        processor = case config.mode
                    when "html"
                      ->(post, similarities) { process_html(post, similarities) }
                    when "json"
                      ->(post, similarities) { process_json(post, similarities) }
                    end

        similarity_scores.each_with_index do |scores, i|
          post = posts[i]
          similarities = scores.max(5).map do |_score, index|
            target = posts[index]
            { id: target.id, title: target.title, permalink: target.permalink }
          end

          processor.call(post, similarities)
        end
      end

      def self.process_html(post, similarities)
        post.define_singleton_method(:similarities) { similarities || [] }
      end

      def self.process_json(post, similarities)
        post.define_singleton_method(:as_json) do |options = {}|
          hash = super(options)
          hash.update({ similarities: similarities })
        end
      end
    end
  end
end
