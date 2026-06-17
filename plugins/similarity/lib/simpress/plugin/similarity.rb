# frozen_string_literal: true
# @plugins/similarity/spec/similarity_spec.rb

require "fileutils"
require "natto"
require "xxhash"
require "simpress/json"
require "simpress/plugin"

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

      def self.run(posts, *_args)
        indexer = Indexer.new(posts)
        indexer.each_similarity do |scores, i|
          similarities = scores.max_by(5, &:first).map do |_score, index|
            target = posts[index]
            [target.id, target.title, target.permalink]
          end

          posts[i] = PostWithSimilarities.new(posts[i], similarities)
        end

        Indexer::Cache.flush
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

          doc_lens       = @vectors.map {|v| v.each_value.sum.to_f }
          avgdl          = doc_lens.sum / @size
          @norm           = doc_lens.map {|dl| K1 * (1.0 - B + (B * dl / avgdl)) }
          @idf            = build_idf
          @inverted_index = build_inverted_index
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

        def build_inverted_index
          Hash.new {|h, k| h[k] = [] }.tap do |index|
            @vectors.each_with_index {|v, i| v.each {|word, weight| index[word] << [i, weight.to_f] } }
            index.select! {|word, _| @idf[word] > 0.0 }
          end
        end

        def extract_keywords(post)
          key = (XXhash.xxh32(post.title) ^ XXhash.xxh32(post.markdown, 1)).to_s
          Cache.fetch(key) do
            NATTO.parse("#{post.title} #{post.markdown}").scan(NATTO_REGEX).map!(&:first)
          end
        end

        def scores_for(i)
          v1 = @vectors[i]
          return [] if v1.empty?

          @accumulator.fill(0.0)

          v1.each_key do |word|
            idf = @idf[word]
            @inverted_index[word].each do |j, weight|
              next if j == i

              denominator = weight + @norm[j]
              @accumulator[j] += idf * ((weight * TF_SCALE) / denominator)
            end
          end

          @accumulator.filter_map.with_index {|score, idx| [score, idx] if score > 0.0 }
        end

        class Cache
          CACHE_FILE = ".cache/similarity.cache"

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
    end
  end
end
