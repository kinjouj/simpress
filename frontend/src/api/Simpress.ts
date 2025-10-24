import type { PostType } from '../types';

type PageInfoType = {
  page: number
};

export default class Simpress {
  public static async getPageInfo(this: void): Promise<number> {
    const data = await Simpress.getData<PageInfoType>('/pageinfo.json');
    return data.page;
  }

  public static async getPostsByPage(this: void, page: number): Promise<PostType[]> {
    return await Simpress.getData<PostType[]>(`/archives/page/${page}.json`);
  }

  public static async getPostsByArchive(this: void, year: number, month: number): Promise<PostType[]> {
    const twoDigitMonth = month.toString().padStart(2, '0');
    return await Simpress.getData<PostType[]>(`/archives/${year}/${twoDigitMonth}.json`);
  }

  public static async getPostsByCategory(this: void, category: string): Promise<PostType[]> {
    return await Simpress.getData<PostType[]>(`/archives/category/${category}.json`);
  }

  public static async getPost(this: void, permalink: string): Promise<PostType> {
    return await Simpress.getData<PostType>(`/${permalink}`);
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
