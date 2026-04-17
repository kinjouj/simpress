import type { TaxonomyType } from './taxonomy';

type TaxonomiesType = {
  categories: TaxonomyType[]
};

export type SimilaritiesType = [id: string, title: string, permalink: string];

export type PostType = {
  id: string
  title: string
  permalink: string
  source: string
  date: string
  cover: string
  content: string
  description: string
  taxonomies: TaxonomiesType
  similarities?: SimilaritiesType[]
};
