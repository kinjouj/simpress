import Simpress from '../../src/api/simpress';
import { testPostData } from '../fixtures/testPostData';

const mockFetch = jest.fn();
globalThis.fetch = mockFetch;

describe('Simpress', () => {
  beforeEach(() => {
    mockFetch.mockClear();
    mockFetch.mockReset();
  });

  test('getPageInfo test', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ page: 3 }),
    });
    const page = await Simpress.getPageInfo();
    expect(page).toBe(3);
  });

  test('getPostsByPage test', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([ testPostData, testPostData ]),
    });
    const posts = await Simpress.getPostsByPage(1);
    expect(posts).toHaveLength(2);
  });

  test('getPostsByArchive test', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([testPostData]),
    });
    const posts = await Simpress.getPostsByArchive(2000, 1);
    expect(posts).toHaveLength(1);
  });

  test('getPostsByCategory test', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([testPostData]),
    });
    const posts = await Simpress.getPostsByCategory('test');
    expect(posts).toHaveLength(1);
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
    /* eslint-disable @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-explicit-any */
    const getData: <T>(url: string) => Promise<T> = (Simpress as any).getData.bind(Simpress);
    /* eslint-enable @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-explicit-any */
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
