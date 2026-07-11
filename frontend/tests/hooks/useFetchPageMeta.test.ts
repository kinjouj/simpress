import { renderHook, waitFor } from '@testing-library/react';
import { useFetchPageMeta } from '../../src/hooks/useFetchPageMeta';
import Simpress from '../../src/api/Simpress';

jest.mock('../../src/api/Simpress');
const SimpressMock = jest.mocked(Simpress);

describe('useFetchPageMeta', () => {
  test('fetches total pages for the given path', async () => {
    SimpressMock.getMeta.mockResolvedValue(3);

    const { result } = renderHook(() => useFetchPageMeta('/archives/page'));

    await waitFor(() => {
      expect(result.current.totalPages).toBe(3);
    });
    expect(SimpressMock.getMeta).toHaveBeenCalledWith('/archives/page');
  });

  test('isOutOfPage returns true once currentPage exceeds totalPages', async () => {
    SimpressMock.getMeta.mockResolvedValue(2);

    const { result } = renderHook(() => useFetchPageMeta('/archives/page'));

    await waitFor(() => {
      expect(result.current.totalPages).toBe(2);
    });

    expect(result.current.isOutOfPage(1)).toBe(false);
    expect(result.current.isOutOfPage(2)).toBe(false);
    expect(result.current.isOutOfPage(3)).toBe(true);
  });

  test('does not fetch and treats every page as in range when path is null', async () => {
    const { result } = renderHook(() => useFetchPageMeta(null));

    await waitFor(() => {
      expect(result.current.totalPages).toBeNull();
    });

    expect(SimpressMock.getMeta).not.toHaveBeenCalled();
    expect(result.current.isOutOfPage(999)).toBe(false);
  });
});
