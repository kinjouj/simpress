import type { CategoryType } from './category';

export type PostType = {
  id: string
  title: string
  permalink: string
  date: string
  cover: string
  content: string
  categories: CategoryType[]
};
