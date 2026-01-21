# frozen_string_literal: true

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

      CATEGORY_WEIGHT = 10

      class CosineSimilarity
        attr_reader :docs, :keywords

        def initialize(posts)
          @posts    = posts
          @docs     = posts.map(&:extract_keywords)
          @keywords = build_keyword_index
        end

        def vectors
          @vectors ||= @posts.zip(docs).map do |post, keywords|
            freq = keywords.each_with_object(Hash.new(0)) {|k, h| h[k] += 1 }
            post.categories.each {|category| freq[category.name] += CATEGORY_WEIGHT }
            freq
          end
        end

        def build_keyword_index
          index = Hash.new {|h, k| h[k] = [] }
          @docs.each_with_index {|keywords, i| keywords.each {|k| index[k] << i } }
          index
        end

        def norms
          @norms ||= vectors.map {|v| Math.sqrt(v.values.sum {|x| x * x }) }
        end

        def each_similarity
          vectors.each_index do |i|
            candidate_indices = @docs[i].flat_map {|k| @keywords[k] }.uniq.reject {|j| j == i }
            candidate_indices.each do |j|
              cosine = cosine(vectors[i], norms[i], vectors[j], norms[j])
              yield i, j, cosine if cosine.positive?
            end
          end
        end

        def cosine(vec1, norm1, vec2, norm2)
          return 0.0 if norm1.zero? || norm2.zero?

          product = if vec1.size < vec2.size
                      vec1.sum {|k, v| v * (vec2[k] || 0) }
                    else
                      vec2.sum {|k, v| v * (vec1[k] || 0) }
                    end

          product / (norm1 * norm2)
        end
      end

      def self.run(posts, _, _)
        related_posts = Array.new(posts.size) { [] }
        cs = CosineSimilarity.new(posts)
        cs.each_similarity do |i, j, cosine|
          similarity = { id: posts[j].id, title: posts[j].title, permalink: posts[j].permalink }
          related_posts[i] << [cosine, similarity] if cosine.positive?
        end

        related_posts.each_with_index do |sim_posts, i|
          base_post = posts[i]
          similarity = sim_posts.max_by(5) {|cosine, _| cosine }.map {|_, post| post }
          result = { title: base_post.title, keywords: cs.docs[i].uniq, similarity: similarity }.to_json

          Simpress::Writer.write("similarity/#{base_post.id}.json", result)
        end
      end
    end
  end
end
