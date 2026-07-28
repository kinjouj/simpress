import { vi } from 'vitest';
import type { PostType, TaxonomyType } from '../../types';

const Simpress = {
  getData: vi.fn<(path: string) => Promise<number | PostType | PostType[]>>(),
  getMeta: vi.fn<(url: string) => Promise<number>>(),
  getPostsByPage: vi.fn<(page: number) => Promise<PostType[]>>(),
  getPostsByArchive: vi.fn<(year: number, month: number, page: number) => Promise<PostType[]>>(),
  getPostsByCategory: vi.fn<(category: string, page: number) => Promise<PostType[]>>(),
  getPost: vi.fn<(slug: string) => Promise<PostType>>(),
  getRecentPosts: vi.fn<() => Promise<PostType[]>>(),
  getCategories: vi.fn<() => Promise<TaxonomyType[]>>(),
};

export default Simpress;
