import type { PostType } from '../types';

export default class Simpress {
  public static getPageInfo(): Promise<number> {
    return Simpress.getData<{ page: number }>('/pageinfo.json').then(({ page }) => page);
  }

  public static getPostsByPage(page: number): Promise<PostType[]> {
    return Simpress.getData<PostType[]>(`/archives/page/${page}.json`);
  }

  public static getPostsByArchive(year: number, month: number): Promise<PostType[]> {
    const twoDigitMonth = month.toString().padStart(2, '0');
    return Simpress.getData<PostType[]>(`/archives/${year}/${twoDigitMonth}.json`);
  }

  public static getPostsByCategory(category: string): Promise<PostType[]> {
    return Simpress.getData<PostType[]>(`/archives/category/${category}.json`);
  }

  public static getPost(permalink: string): Promise<PostType> {
    return Simpress.getData<PostType>(permalink);
  }

  public static getRecentPosts(): Promise<PostType[]> {
    return Simpress.getData<PostType[]>('/recent_posts.json');
  }

  private static async getData<T>(path: string): Promise<T> {
    const res = await fetch(path);

    if (!res.ok) {
      throw new Error('ERROR');
    }

    return await res.json() as T;
  }
}
