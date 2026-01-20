import type { CategoryType } from './category-type';

export type PostType = {
  id: string
  title: string
  permalink: string
  date: string
  cover: string
  content: string
  description: string
  categories: CategoryType[]
};

export type SimilarityType = {
  title: string
  keywords: string[]
  similarity: Pick<PostType, 'id' | 'title' | 'permalink'>[]
};
