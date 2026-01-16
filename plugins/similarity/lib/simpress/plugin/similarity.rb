# frozen_string_literal: true

module Simpress
  module Plugin
    class Similarity
      extend Simpress::Plugin

      def self.run(posts, _, _)
        docs = posts.map(&:extract_keywords)
        vectors = posts.zip(docs).map do |post, keywords|
          freq = Hash.new(0)
          keywords.each {|k| freq[k] += 1 }
          post.categories.each {|category| freq[category.name] += 10 }
          freq
        end

        norms = vectors.map { |v| Math.sqrt(v.values.sum { |x| x * x }) }
        keyword_map = Hash.new {|h, k| h[k] = Set.new }
        docs.each_with_index {|keywords, i| keywords.each {|k| keyword_map[k] << i } }

        related_posts_list = Array.new(posts.size) { [] }

        vectors.each_with_index do |vec1, i|
          norm1 = norms[i]
          next if norm1.zero?

          candidate_indices = docs[i].flat_map {|k| keyword_map[k].to_a }.to_set
          candidate_indices.delete(i)
          candidate_indices.each do |j|
            vec2  = vectors[j]
            norm2 = norms[j]
            next if norm2.zero?

            product = vec1.size < vec2.size ? vec1.sum {|k, v| v * vec2[k] } : vec2.sum {|k, v| v * vec1[k] }
            cosine = product / (norm1 * norm2)
            related_posts_list[i] << [cosine, { title: posts[j].title, permalink: posts[j].permalink }] if cosine > 0.0
          end
        end

        related_posts_list.each_with_index do |related_posts, i|
          base_post = posts[i]
          sim_posts = related_posts.max_by(5) {|cosine, _| cosine }.map {|_, post| post }
          result = { title: base_post.title, keywords: docs[i].uniq, similarity: sim_posts }.to_json

          Simpress::Writer.write("similarity/#{base_post.id}.json", result)
        end
      end
    end
  end
end
