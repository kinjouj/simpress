import type { CategoryType } from './Category';

export type PostType = {
  id: string
  title: string
  permalink: string
  date: string
  cover: string
  content: string
  categories: CategoryType[]
};
