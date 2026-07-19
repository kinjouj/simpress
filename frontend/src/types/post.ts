export type TaxonomyType = {
  key: string
  name: string
  count?: number
  children?: TaxonomyType[]
};

export type TaxonomiesType = Record<string, TaxonomyType[]>;

export type AdjacentSummaryType = Pick<PostType, 'id' | 'title' | 'permalink'>;

export type AdjacentType = {
  prev: AdjacentSummaryType | null
  next: AdjacentSummaryType | null
};

export type TocType = {
  id: string
  text: string
  children: Omit<TocType, 'children'>[]
};

export type SimilaritiesType = [id: string, title: string, permalink: string];

export type PostType = {
  id: string
  title: string
  permalink: string
  date: string
  taxonomies: TaxonomiesType
  content?: string
  cover?: string
  description?: string
  toc?: TocType[]
  adjacent?: AdjacentType
  similarities?: SimilaritiesType[]
};
