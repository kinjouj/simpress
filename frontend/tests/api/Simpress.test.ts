import Simpress from '../../src/api/Simpress';
import { testPostData } from '../fixtures/testPostData';

const mockFetch = vi.fn();
globalThis.fetch = mockFetch;

describe('Simpress', () => {
  beforeEach(() => {
    mockFetch.mockClear();
    mockFetch.mockReset();
  });

  test('getPostsByPage test', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ posts: [testPostData, testPostData], total_pages: 1 }),
    });
    const { posts, total_pages: totalPages } = await Simpress.getPostsByPage(1);
    expect(posts).toHaveLength(2);
    expect(totalPages).toBe(1);
  });

  test('getPostsByArchive test', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ posts: [testPostData], total_pages: 1 }),
    });
    const { posts, total_pages: totalPages } = await Simpress.getPostsByArchive(2000, 1, 1);
    expect(posts).toHaveLength(1);
    expect(totalPages).toBe(1);
  });

  test('getPostsByCategory test', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ posts: [testPostData], total_pages: 1 }),
    });
    const { posts, total_pages: totalPages } = await Simpress.getPostsByCategory('test', 1);
    expect(posts).toHaveLength(1);
    expect(totalPages).toBe(1);
  });

  test('getPost test', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(testPostData),
    });
    const post = await Simpress.getPost('/test');
    expect(post).not.toBeNull();
    expect(mockFetch).toHaveBeenCalled();
  });

  test('getData test', async () => {
    const getData: <T>(url: string) => Promise<T> = (Simpress as any).getData.bind(Simpress); // eslint-disable-line
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ test: true }),
    });
    const result = await getData('/test');
    expect(result).toHaveProperty('test', true);

    mockFetch.mockResolvedValue({ ok: false });
    await expect(async () => { await getData('/test'); }).rejects.toThrow();
  });
});
