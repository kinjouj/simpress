import type { EntriesPageType, EntryLinkType, EntryType, TaxonomyType } from '../types';

export default class Simpress {
  public static getEntriesByPage(page: number): Promise<EntriesPageType> {
    return Simpress.getData(`/archives/page/${page}.json`);
  }

  public static getEntriesByArchive(year: number, month: number, page: number): Promise<EntriesPageType> {
    const twoDigitMonth = month.toString().padStart(2, '0');
    return Simpress.getData(`/archives/${year}/${twoDigitMonth}/${page}.json`);
  }

  public static getEntriesByCategory(category: string, page: number): Promise<EntriesPageType> {
    return Simpress.getData(`/archives/categories/${category}/${page}.json`);
  }

  public static getEntry(permalink: string): Promise<EntryType> {
    return Simpress.getData(permalink);
  }

  public static getRecentEntries(): Promise<EntryLinkType[]> {
    return Simpress.getData('/recent_entries.json');
  }

  public static getCategories(): Promise<TaxonomyType[]> {
    return Simpress.getData('/categories.json');
  }

  private static async getData<T>(path: string): Promise<T> {
    const res = await fetch(path);

    if (!res.ok) {
      throw new Error('ERROR');
    }

    return await res.json() as T;
  }
}
