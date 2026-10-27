import { vi } from 'vitest';
import type { EntriesPageType, EntryLinkType, EntryType, TaxonomyType } from '../../types';

const Simpress = {
  getData: vi.fn<(path: string) => Promise<number | EntryType | EntryType[]>>(),
  getEntriesByPage: vi.fn<(page: number) => Promise<EntriesPageType>>(),
  getEntriesByArchive: vi.fn<(year: number, month: number, page: number) => Promise<EntriesPageType>>(),
  getEntriesByCategory: vi.fn<(category: string, page: number) => Promise<EntriesPageType>>(),
  getEntry: vi.fn<(slug: string) => Promise<EntryType>>(),
  getRecentEntries: vi.fn<() => Promise<EntryLinkType[]>>(),
  getCategories: vi.fn<() => Promise<TaxonomyType[]>>(),
};

export default Simpress;
