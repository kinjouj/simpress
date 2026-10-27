export type TaxonomyType = {
  key: string
  name: string
  count?: number
  children?: TaxonomyType[]
};

export type DateType = {
  year: number
  month: number
  day: number
  hour: number
  minute: number
  second: number
  utc_offset: number
};

export type TaxonomiesType = Record<string, TaxonomyType[]>;
export type EntryLinkType = Pick<EntryType, 'id' | 'title' | 'permalink'>;
export type EntryIndexType = Pick<EntryType, 'id' | 'title' | 'permalink' | 'date' | 'taxonomies' | 'cover' | 'description'>;

export type TocType = {
  id: string
  text: string
  children: Omit<TocType, 'children'>[]
};

export type EntryType = {
  id: string
  title: string
  permalink: string
  date: DateType | null
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
  entries: EntryIndexType[]
  total_pages: number
};
