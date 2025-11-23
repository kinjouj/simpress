import type Simpress from '../../../../src/api/simpress';
import type { PostType } from '../../../../src/types';

const SimpressMock = {
  getPageInfo: jest.fn<Promise<number>, []>(),
  getPostsByPage: jest.fn<Promise<PostType[]>, [ number ]>(),
  getPostsByArchive: jest.fn<Promise<PostType[]>, [ number, number ]>(),
  getPostsByCategory: jest.fn<Promise<PostType[]>, [ string ]>(),
  getPost: jest.fn<Promise<PostType>, [ string ]>(),
};

export default SimpressMock as unknown as jest.Mocked<typeof Simpress>;
