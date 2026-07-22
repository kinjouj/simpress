export type TaxonomyType = {
  key: string
  name: string
  count?: number
  children?: TaxonomyType[]
};

export type TaxonomiesType = Record<string, TaxonomyType[]>;
export type PostLinkType = Pick<PostType, 'id' | 'title' | 'permalink'>;
export type AdjacentType = Record<'prev' | 'next', PostLinkType | null>;

export type TocType = {
  id: string
  text: string
  children: Omit<TocType, 'children'>[]
};

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
  similarities?: PostLinkType[]
};
