import Simpress from '../../src/api/Simpress';
import { testEntryData } from '../fixtures/testEntryData';

const mockFetch = vi.fn();

describe('Simpress', () => {
  beforeEach(() => {
    vi.stubGlobal('fetch', mockFetch);
  });

  it('fetches entries by page', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ entries: [testEntryData, testEntryData], total_pages: 1 }),
    });
    const { entries, total_pages: totalPages } = await Simpress.getEntriesByPage(1);
    expect(mockFetch).toHaveBeenCalledWith('/archives/page/1.json');
    expect(entries).toHaveLength(2);
    expect(totalPages).toBe(1);
  });

  it('fetches entries by archive', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ entries: [testEntryData], total_pages: 1 }),
    });
    const { entries, total_pages: totalPages } = await Simpress.getEntriesByArchive(2000, 1, 1);
    expect(mockFetch).toHaveBeenCalledWith('/archives/2000/01/1.json');
    expect(entries).toHaveLength(1);
    expect(totalPages).toBe(1);
  });

  it('fetches entries by category', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ entries: [testEntryData], total_pages: 1 }),
    });
    const { entries, total_pages: totalPages } = await Simpress.getEntriesByCategory('test', 1);
    expect(mockFetch).toHaveBeenCalledWith('/archives/categories/test/1.json');
    expect(entries).toHaveLength(1);
    expect(totalPages).toBe(1);
  });

  it('fetches an entry', async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      json: () => Promise.resolve(testEntryData),
    });
    const entry = await Simpress.getEntry('/test');
    expect(entry).toEqual(testEntryData);
    expect(mockFetch).toHaveBeenCalledWith('/test');
  });

  it('returns data or throws', async () => {
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
