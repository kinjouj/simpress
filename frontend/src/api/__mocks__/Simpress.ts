import type { PostType } from '../../types';

const Simpress = {
  getPageInfo: jest.fn<Promise<number>, []>(),
  getPostsByPage: jest.fn<Promise<PostType[]>, [number]>(),
  getPostsByArchive: jest.fn<Promise<PostType[]>, [ number, number ]>(),
  getPostsByCategory: jest.fn<Promise<PostType[]>, [string]>(),
  getPost: jest.fn<Promise<PostType>, [string]>(),
};

export default Simpress;
