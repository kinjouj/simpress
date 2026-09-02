# frozen_string_literal: true
# @plugins/similarity/spec/similarity_spec.rb

require "delegate"
require "fileutils"
require "msgpack"
require "natto"
require "xxhash"
require "simpress/json"
require "simpress/plugin"
require "simpress/post"

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

      def self.run(posts, *_args)
        indexer = Indexer.new(posts)
        indexer.each_similarity do |scores, i|
          similarities = scores.max_by(5) {|score, _| score }.map {|_score, index| Simpress::Post::PostLink.new(posts[index]) }
          posts[i] = PostWithSimilarities.new(posts[i], similarities)
        end

        Indexer::Cache.flush
      end

      class Indexer
        NATTO_REGEX = /^([[:alnum:]]{3,})\t名詞,(?:固有名詞|一般)/
        NATTO       = Natto::MeCab.new
        K1          = 1.2
        B           = 0.75
        TF_SCALE    = K1 + 1.0
        LINK_WEIGHT = 10.0

        attr_reader :keywords

        def initialize(posts)
          @size           = posts.size
          @accumulator    = Array.new(@size, 0.0)
          @touched        = Array.new(@size)
          @keywords       = {}
          @backlink_pairs = []
          permalink_index = posts.each_with_index.to_h {|post, i| [post.permalink, i] }
          doc_lens        = []
          @vectors = posts.map do |post|
            @backlink_pairs << (post.backlinks || []).filter_map {|entry| permalink_index[entry.permalink] }

            keywords = extract_keywords(post)
            vector   = keywords.tally
            post.taxonomies.each_value do |terms|
              terms.each do |term|
                n = term.name
                v = vector[n] || 0
                vector[n] = v + (Math.log2(v + 2) * 3)
              end
            end

            vector.select! {|_, v| v >= 2 }
            @keywords[post.id] = keywords
            doc_lens << vector.each_value.sum.to_f
            vector
          end

          avgdl = doc_lens.sum / @size
          norm  = doc_lens.map {|dl| K1 * (1.0 - B + (B * dl / avgdl)) }
          @idf, @inverted_index = build_idf_and_inverted_index(norm)
        end

        def each_similarity
          @size.times {|i| yield scores_for(i), i }
        end

        private

        def build_idf_and_inverted_index(norm)
          df    = Hash.new(0)
          index = Hash.new {|h, k| h[k] = [] }

          @vectors.each_with_index do |v, i|
            ni = norm[i]
            v.each do |word, weight|
              df[word] += 1
              term_score = (weight * TF_SCALE) / (weight + ni)
              index[word] << [i, term_score]
            end
          end

          idf = Hash.new(0.0)
          df.each {|word, count| idf[word] = Math.log(((@size - count + 0.5) / (count + 0.5)) + 1.0) }

          [idf, index]
        end

        def extract_keywords(post)
          key = (XXhash.xxh32(post.title) ^ XXhash.xxh32(post.markdown, 1)).to_s
          Cache.fetch(key) { NATTO.parse("#{post.title} #{post.markdown}").scan(NATTO_REGEX).map!(&:first) }
        end

        def scores_for(i)
          v1 = @vectors[i]

          touched_count = 0

          v1.each_key do |word|
            idf = @idf[word]
            @inverted_index[word].each do |j, term_score|
              next if j == i

              if @accumulator[j] == 0.0
                @touched[touched_count] = j
                touched_count += 1
              end

              @accumulator[j] += idf * term_score
            end
          end

          @backlink_pairs[i].each do |j|
            next if j == i

            if @accumulator[j] == 0.0
              @touched[touched_count] = j
              touched_count += 1
            end

            @accumulator[j] *= LINK_WEIGHT
          end

          result = Array.new(touched_count)
          touched_count.times do |k|
            j = @touched[k]
            result[k] = [@accumulator[j], j]
            @accumulator[j] = 0.0
          end

          result
        end

        class Cache
          CACHE_FILE = "similarity.cache"

          class << self
            def fetch(key)
              return store[key] if store.key?(key)

              result = yield
              store[key] = result
              result
            end

            def flush
              File.binwrite(CACHE_FILE, store.to_msgpack)
            end

            private

            def store
              @store ||= (MessagePack.unpack(File.binread(CACHE_FILE)) if File.exist?(CACHE_FILE)) || {}
            end
          end
        end
      end

      class PostWithSimilarities < SimpleDelegator
        include Simpress::JSON::Serializable

        attr_reader :similarities

        def initialize(post, similarities)
          super(post)
          @similarities = similarities
        end

        def to_h(state = {})
          hash = __getobj__.to_h(state)
          hash[:similarities] = @similarities if hash.key?(:content)
          hash
        end
      end
    end
  end
end
