import { vi } from 'vitest';
import type { PagedPostsType, PostType, TaxonomyType } from '../../types';

const Simpress = {
  getData: vi.fn<(path: string) => Promise<number | PostType | PostType[]>>(),
  getPostsByPage: vi.fn<(page: number) => Promise<PagedPostsType>>(),
  getPostsByArchive: vi.fn<(year: number, month: number, page: number) => Promise<PagedPostsType>>(),
  getPostsByCategory: vi.fn<(category: string, page: number) => Promise<PagedPostsType>>(),
  getPost: vi.fn<(slug: string) => Promise<PostType>>(),
  getRecentPosts: vi.fn<() => Promise<PostType[]>>(),
  getCategories: vi.fn<() => Promise<TaxonomyType[]>>(),
};

export default Simpress;
