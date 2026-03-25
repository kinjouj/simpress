import type { CategoriesType, PostType } from '../types';

export default class Simpress {
  public static async getMeta(path: string): Promise<number> {
    const meta: { total_pages: number } = await Simpress.getData<{ total_pages: number }>(`${path}/meta.json`);
    return meta.total_pages;
  }

  public static getPostsByPage(page: number): Promise<PostType[]> {
    return Simpress.getData<PostType[]>(`/archives/page/${page}.json`);
  }

  public static getPostsByArchive(year: number, month: number, page: number): Promise<PostType[]> {
    const twoDigitMonth = month.toString().padStart(2, '0');
    return Simpress.getData<PostType[]>(`/archives/${year}/${twoDigitMonth}/${page}.json`);
  }

  public static getPostsByCategory(category: string, page: number): Promise<PostType[]> {
    return Simpress.getData<PostType[]>(`/archives/category/${category}/${page}.json`);
  }

  public static getPost(permalink: string): Promise<PostType> {
    return Simpress.getData<PostType>(permalink);
  }

  public static getRecentPosts(): Promise<PostType[]> {
    return Simpress.getData<PostType[]>('/recent_posts.json');
  }

  public static getCategories(): Promise<CategoriesType> {
    return Simpress.getData<CategoriesType>('/categories.json');
  }

  private static async getData<T>(path: string): Promise<T> {
    const res = await fetch(path);

    if (!res.ok) {
      throw new Error('ERROR');
    }

    return await res.json() as T;
  }
}
