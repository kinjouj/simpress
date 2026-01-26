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
  similarities?: SimilarityType[]
};

export type SimilarityType = Pick<PostType, 'id' | 'title' | 'permalink'>;
