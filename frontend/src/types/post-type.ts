type TaxonomyType = {
  key: string
  name: string
};

type TaxonomiesType = {
  categories: TaxonomyType[]
};

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

export type SimilaritiesType = [id: string, title: string, permalink: string];
