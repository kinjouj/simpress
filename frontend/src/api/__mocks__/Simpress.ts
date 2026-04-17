import type { PostType, TaxonomyType } from '../../types';

const Simpress = {
  getMeta: jest.fn<Promise<number>, [string]>(),
  getPostsByPage: jest.fn<Promise<PostType[]>, [number]>(),
  getPostsByArchive: jest.fn<Promise<PostType[]>, [ number, number ]>(),
  getPostsByCategory: jest.fn<Promise<PostType[]>, [string]>(),
  getPost: jest.fn<Promise<PostType>, [string]>(),
  getRecentPosts: jest.fn<Promise<PostType[]>, []>(),
  getCategories: jest.fn<Promise<TaxonomyType[]>, []>(),
};

export default Simpress;
