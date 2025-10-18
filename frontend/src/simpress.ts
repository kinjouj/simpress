import type { PostType, PageInfoType } from './types';

export default class Simpress {
  public static async getPageInfo(): Promise<number> {
    const data = await this.getData<PageInfoType>('/pageinfo.json');
    return data.page;
  }

  public static async getPostsByPage(page: number): Promise<PostType[]> {
    return await this.getData<PostType[]>(`/archives/page/${page}.json`);
  }

  public static async getPostsByArchive(year: number, month: number): Promise<PostType[]> {
    const twoDigitMonth = month.toString().padStart(2, '0');
    return await this.getData<PostType[]>(`/archives/${year}/${twoDigitMonth}.json`);
  }

  public static async getPostsByCategory(category: string): Promise<PostType[]> {
    return await this.getData<PostType[]>(`/archives/category/${category}.json`);
  }

  public static async getPost(permalink: string): Promise<PostType> {
    return await this.getData<PostType>(`/${permalink}`);
  }

  private static async getData<T>(path: string): Promise<T> {
    const res = await fetch(path);

    if (!res.ok) {
      return Promise.reject(new Error('ERROR'));
    }

    const data: T = await res.json() as T;
    return data;
  }
}
