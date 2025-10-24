import Simpress from '../../src/api/Simpress';

describe('Simpress', () => {
  test('getPageInfo test', async () => {
    globalThis.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ page: 3 }),
    });

    const page = await Simpress.getPageInfo();
    expect(page).toBe(3);
  });

  test('getPostsByPage test', async () => {
    globalThis.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([{}, {}]),
    } as Response);

    const posts = await Simpress.getPostsByPage(1);
    expect(posts).toHaveLength(2);
  });

  test('getPostsByArchive test', async () => {
    globalThis.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([{}]),
    });
    const posts = await Simpress.getPostsByArchive(2000, 1);
    expect(posts).toHaveLength(1);
  });

  test('getPostsByCategory test', async () => {
    globalThis.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([{}]),
    });
    const posts = await Simpress.getPostsByCategory('test');
    expect(posts).toHaveLength(1);
  });

  test('getPost test', async () => {
    globalThis.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({}),
    });
    const post = await Simpress.getPost('/test');
    expect(post).not.toBeNull();
  });

  test('getData test', async () => {
    /* eslint-disable @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-explicit-any */
    const getData: <T>(url: string) => Promise<T> = (Simpress as any).getData.bind(Simpress);
    /* eslint-enable @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-explicit-any */
    globalThis.fetch = jest.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ test: true }),
    });
    const result = await getData('/test');
    expect(result).toHaveProperty('test', true);

    globalThis.fetch = jest.fn().mockResolvedValue({ ok: false });
    await expect(async () => { await getData('/test'); }).rejects.toThrow();
  });
});
