import type { PagedPostsType, PostType, TaxonomyType } from '../types';

export default class Simpress {
  public static getPostsByPage(page: number): Promise<PagedPostsType> {
    return Simpress.getData<PagedPostsType>(`/archives/page/${page}.json`);
  }

  public static getPostsByArchive(year: number, month: number, page: number): Promise<PagedPostsType> {
    const twoDigitMonth = month.toString().padStart(2, '0');
    return Simpress.getData<PagedPostsType>(`/archives/${year}/${twoDigitMonth}/${page}.json`);
  }

  public static getPostsByCategory(category: string, page: number): Promise<PagedPostsType> {
    return Simpress.getData<PagedPostsType>(`/archives/categories/${category}/${page}.json`);
  }

  public static getPost(permalink: string): Promise<PostType> {
    return Simpress.getData<PostType>(permalink);
  }

  public static getRecentPosts(): Promise<PostType[]> {
    return Simpress.getData<PostType[]>('/recent_posts.json');
  }

  public static getCategories(): Promise<TaxonomyType[]> {
    return Simpress.getData<TaxonomyType[]>('/categories.json');
  }

  private static async getData<T>(path: string): Promise<T> {
    const res = await fetch(path);

    if (!res.ok) {
      throw new Error('ERROR');
    }

    return await res.json() as T;
  }
}
