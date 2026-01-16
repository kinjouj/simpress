# frozen_string_literal: true

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

      CATEGORY_WEIGHT = 10

      def self.run(posts, _, _)
        docs    = posts.map(&:extract_keywords)
        vectors = posts.zip(docs).map do |post, keywords|
          freq = Hash.new(0)
          keywords.each {|k| freq[k] += 1 }
          post.categories.each {|category| freq[category.name] += CATEGORY_WEIGHT }
          freq
        end

        related_posts = Array.new(posts.size) { [] }
        norms         = vectors.map { |v| Math.sqrt(v.values.sum { |x| x * x }) }
        keyword_map   = Hash.new {|h, k| h[k] = [] }
        docs.each_with_index {|keywords, i| keywords.each {|k| keyword_map[k] << i } }

        vectors.each_with_index do |vec1, i|
          norm1 = norms[i]
          next if norm1.zero?

          candidate_indices = docs[i].flat_map {|k| keyword_map[k] }.uniq.reject {|j| j == i }
          candidate_indices.each do |j|
            norm2 = norms[j]
            next if norm2.zero?

            vec2    = vectors[j]
            product = if vec1.size < vec2.size
                        vec1.sum {|k, v| v * (vec2[k] || 0) }
                      else
                        vec2.sum {|k, v| v * (vec1[k] || 0) }
                      end

            cosine = product / (norm1 * norm2)
            related_posts[i] << [cosine, { title: posts[j].title, permalink: posts[j].permalink }] if cosine.positive?
          end
        end

        related_posts.each_with_index do |sim_posts, i|
          base_post = posts[i]
          similarity = sim_posts.max_by(5) {|cosine, _| cosine }.map {|_, post| post }
          result = { title: base_post.title, keywords: docs[i].uniq, similarity: similarity }.to_json

          Simpress::Writer.write("similarity/#{base_post.id}.json", result)
        end
      end
    end
  end
end
