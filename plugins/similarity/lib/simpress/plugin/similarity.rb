# frozen_string_literal: true

require "natto"
require "xxhash"
require "simpress/json"
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
          similarities = scores.max_by(5, &:first).map do |_score, index|
            target = posts[index]
            [target.id, target.title, target.permalink]
          end

          posts[i] = PostWithSimilarities.new(posts[i], similarities)
        end
      end

      class PostWithSimilarities
        extend Forwardable

        def_delegators :@post, :id, :title, :date, :permalink, :description, :content, :toc, :layout, :cover, :taxonomies

        attr_reader :similarities

        def initialize(post, similarities)
          @post = post
          @similarities = similarities
        end

        def to_h(state = {})
          hash = @post.to_h(state)
          hash[:similarities] = @similarities if hash.key?(:content)
          hash
        end

        def as_json(options = {})
          to_h(options)
        end

        def to_json(options = {})
          Simpress::JSON.dump(as_json(options))
        end
      end

      class CosineSimilarity
        NATTO_REGEX = /\A([[:alnum:]]{4,})\t名詞,(?:固有名詞|一般),[^\n]*/
        NATTO       = Natto::MeCab.new
        HASH_BITS   = 24
        BANDS       = 6
        SEED_CACHE  = Hash.new {|h, word| h[word] = XXhash.xxh32(word) }

        attr_reader :keywords

        def initialize(posts)
          @keywords = {}
          @size = posts.size
          @data = posts.map do |post|
            keywords = extract_keywords(post)
            vector = keywords.tally
            post.taxonomies.each_value do |terms|
              terms.each do |term|
                n = term.name
                v = vector[n] || 0
                vector[n] = v + (Math.log2(v + 2) * 3)
              end
            end

            vector.select! {|_, v| v >= 2 }
            @keywords[post.id] = vector
            norm = Math.sqrt(vector.each_value.sum(0.0) {|v| v * v })
            { vector: vector, norm: norm, simhash: calculate_simhash(vector) }
          end
        end

        def each_similarity
          band_bits  = HASH_BITS / BANDS
          mask       = (1 << band_bits) - 1
          indices    = (0...@size).to_a
          candidates = Array.new(@size * @size, false)
          BANDS.times do |b|
            shift = b * band_bits
            indices.group_by {|i| (@data[i][:simhash] >> shift) & mask }.each_value do |ids|
              next if ids.size < 2

              ids.combination(2) do |i, j|
                i, j = j, i if i > j
                idx = (i * @size) + j
                next if candidates[idx]

                candidates[idx] = true
                score = cosine(i, j)
                yield i, j, score if score > 0.1
              end
            end
          end
        end

        private

        def extract_keywords(post)
          key = (XXhash.xxh32(post.title) ^ XXhash.xxh32(post.markdown, 1)).to_s
          Cache.fetch(key) do
            data     = "#{post.title}\n#{post.markdown}"
            keywords = []
            NATTO.parse(data).each_line do |line|
              keywords << Regexp.last_match(1) if line =~ NATTO_REGEX
            end

            keywords
          end
        end

        def calculate_simhash(vector)
          v = Array.new(HASH_BITS, 0)
          vector.each do |word, weight|
            seed = SEED_CACHE[word]
            HASH_BITS.times {|bit| v[bit] += weight * ((2 * seed[bit]) - 1) }
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
          def self.fetch(key)
            path = ".cache/#{key}.cache"
            return Marshal.load(File.binread(path)) if File.exist?(path) # rubocop:disable Security/MarshalLoad

            result = yield
            File.binwrite(path, Marshal.dump(result))
            result
          end
        end
      end
    end
  end
end
