export type TaxonomyType = {
  key: string
  name: string
  count?: number
  children?: TaxonomyType[]
};

export type TaxonomiesType = Record<string, TaxonomyType[]>;
export type EntryLinkType = Pick<EntryType, 'id' | 'title' | 'permalink'>;

export type TocType = {
  id: string
  text: string
  children: Omit<TocType, 'children'>[]
};

export type EntryType = {
  id: string
  title: string
  permalink: string
  date: string
  taxonomies: TaxonomiesType
  content?: string
  cover?: string
  description?: string
  toc: TocType[]
  next: EntryLinkType | null
  prev: EntryLinkType | null
  similarities?: EntryLinkType[]
};

export type EntriesPageType = {
  entries: EntryType[]
  total_pages: number
};
