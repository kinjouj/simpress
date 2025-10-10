import { useParams } from 'react-router';
import type { PostType, PageInfoType } from './types';

export default class Simpress {
  public static getPageInfo(): Promise<number> {
    return new Promise((resolve, reject) => {
      this.getData<PageInfoType>('/pageinfo.json').then((data) => {
        const page = data.page;
        resolve(page);
      }).catch(reject);
    });
  }

  public static getPostsByPage(page: number): Promise<PostType[]> {
    return new Promise((resolve, reject) => {
      this.getData<PostType[]>(`/archives/page/${page}.json`).then(data => resolve(data)).catch(reject);
    });
  }

  public static getPostsByCategory(category: string): Promise<PostType[]> {
    return new Promise((resolve, reject) => {
      this.getData<PostType[]>(`/archives/category/${category}.json`).then(data => resolve(data)).catch(reject);
    });
  }

  public static getPost(permalink: string): Promise<PostType> {
    return new Promise((resolve, reject) => {
      this.getData<PostType>(`/${permalink}`).then(data => resolve(data)).catch(reject);
    });
  }

  private static getData<T>(path: string): Promise<T> {
    return new Promise((resolve, reject) => {
      fetch(path).then((res) => {
        if (!res.ok) {
          throw new Error('ERROR');
        }

        res.json().then((data: T) => resolve(data)).catch(reject);
      }).catch(reject);
    });
  }

  public static React = class {
    public static getPage(): number {
      const { page = '1' } = useParams();
      return parseInt(page, 10);
    }

    public static getCategory(): string | undefined {
      const { category } = useParams();
      return category;
    }

    public static getPermalink(): string | undefined {
      const params = useParams();
      return params['*'];
    }
  };
}
