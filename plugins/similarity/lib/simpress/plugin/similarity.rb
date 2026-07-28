# frozen_string_literal: true
# @plugins/similarity/spec/similarity_spec.rb

require "delegate"
require "fileutils"
require "natto"
require "xxhash"
require "simpress/json"
require "simpress/plugin"

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

      PostLink = Data.define(:id, :title, :permalink)

      def self.run(posts, *_args)
        indexer = Indexer.new(posts)
        indexer.each_similarity do |scores, i|
          similarities = scores.max_by(5, &:first).map do |_score, index|
            target = posts[index]
            PostLink.new(id: target.id, title: target.title, permalink: target.permalink)
          end

          posts[i] = PostWithSimilarities.new(posts[i], similarities)
        end

        Indexer::Cache.flush
      end

      class Indexer
        NATTO_REGEX = /^([[:alnum:]]{4,})\t名詞,(?:固有名詞|一般)/
        NATTO       = Natto::MeCab.new
        K1          = 1.2
        B           = 0.75
        TF_SCALE    = K1 + 1.0

        attr_reader :keywords

        def initialize(posts)
          @size        = posts.size
          @accumulator = Array.new(@size, 0.0)
          @touched     = Array.new(@size)
          @keywords    = {}
          @vectors     = posts.map do |post|
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
            vector
          end

          doc_lens        = @vectors.map {|v| v.each_value.sum.to_f }
          avgdl           = doc_lens.sum / @size
          norm            = doc_lens.map {|dl| K1 * (1.0 - B + (B * dl / avgdl)) }
          @idf            = build_idf
          @inverted_index = build_inverted_index(norm)
        end

        def each_similarity
          @size.times {|i| yield scores_for(i), i }
        end

        private

        def build_idf
          df = @vectors.each_with_object(Hash.new(0)) {|v, h| v.each_key {|word| h[word] += 1 } }
          Hash.new(0.0).tap do |idf|
            df.each {|word, count| idf[word] = Math.log(((@size - count + 0.5) / (count + 0.5)) + 1.0) }
          end
        end

        def build_inverted_index(norm)
          Hash.new {|h, k| h[k] = [] }.tap do |index|
            @vectors.each_with_index do |v, i|
              ni = norm[i]
              v.each do |word, weight|
                term_score = (weight * TF_SCALE) / (weight + ni)
                index[word] << [i, term_score]
              end
            end
          end
        end

        def extract_keywords(post)
          key = (XXhash.xxh32(post.title) ^ XXhash.xxh32(post.markdown, 1)).to_s
          Cache.fetch(key) { NATTO.parse("#{post.title} #{post.markdown}").scan(NATTO_REGEX).map!(&:first) }
        end

        def scores_for(i)
          v1 = @vectors[i]
          return [] if v1.empty?

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
              File.binwrite(CACHE_FILE, Marshal.dump(@store))
            end

            private

            def store
              @store ||= (Marshal.load(File.binread(CACHE_FILE)) if File.exist?(CACHE_FILE)) || {} # rubocop:disable Security/MarshalLoad
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
