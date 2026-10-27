import Simpress from '../../src/api/Simpress';
import { testEntryData } from '../fixtures/testEntryData';

const mockFetch = vi.fn();
globalThis.fetch = mockFetch;

describe('Simpress', () => {
  it('ページ別のエントリを取得する', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ entries: [testEntryData, testEntryData], total_pages: 1 }),
    });
    const { entries, total_pages: totalPages } = await Simpress.getEntriesByPage(1);
    expect(entries).toHaveLength(2);
    expect(totalPages).toBe(1);
  });

  it('アーカイブ別のエントリを取得する', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ entries: [testEntryData], total_pages: 1 }),
    });
    const { entries, total_pages: totalPages } = await Simpress.getEntriesByArchive(2000, 1, 1);
    expect(entries).toHaveLength(1);
    expect(totalPages).toBe(1);
  });

  it('カテゴリ別のエントリを取得する', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ entries: [testEntryData], total_pages: 1 }),
    });
    const { entries, total_pages: totalPages } = await Simpress.getEntriesByCategory('test', 1);
    expect(entries).toHaveLength(1);
    expect(totalPages).toBe(1);
  });

  it('エントリを取得する', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(testEntryData),
    });
    const entry = await Simpress.getEntry('/test');
    expect(entry).not.toBeNull();
    expect(mockFetch).toHaveBeenCalled();
  });

  it('レスポンスを返し、失敗時は例外を投げる', async () => {
    const getData: <T>(url: string) => Promise<T> = (Simpress as any).getData.bind(Simpress); // eslint-disable-line
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ test: true }),
    });
    const result = await getData('/test');
    expect(result).toHaveProperty('test', true);

    mockFetch.mockResolvedValue({ ok: false });
    await expect(getData('/test')).rejects.toThrow();
  });
});
