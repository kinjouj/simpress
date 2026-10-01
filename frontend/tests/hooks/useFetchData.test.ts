import { useCallback } from 'react';
import { renderHook, waitFor } from '@testing-library/react';
import { useFetchData } from '../../src/hooks';
import { testEntryData } from '../fixtures/testEntryData';
import type { EntryType } from '../../src/types';

describe('useFetchData', () => {
  describe('useFetchData test', () => {
    it('isLoading is true on initial render, before the fetcher resolves', () => {
      const { result } = renderHook(() => {
        const fetcher = useCallback(() => new Promise<EntryType>(() => {}), []);
        return useFetchData(fetcher);
      });

      const { data, isLoading, isError } = result.current;
      expect(isLoading).toBe(true);
      expect(isError).toBe(false);
      expect(data).toBeNull();
    });

    it('successful', async () => {
      const { result } = renderHook(() => {
        const fetcher = useCallback(() => Promise.resolve(testEntryData), []);
        return useFetchData(fetcher);
      });

      await waitFor(() => {
        const { data, isLoading, isError } = result.current;
        expect(isLoading).toBe(false);
        expect(isError).toBe(false);
        expect(data?.title).toBe('test1');
      });
    });

    it('unmount test', async () => {
      const { result, unmount } = renderHook(() => {
        const fetcher = useCallback(() => Promise.resolve(testEntryData), []);
        return useFetchData(fetcher);
      });

      unmount();

      await waitFor(() => {
        const { data, isError } = result.current;
        expect(data).toBeNull();
        expect(isError).toBe(false);
      });
    });
  });

  describe('if fetcher throw error', () => {
    it('successful', async () => {
      const { result } = renderHook(() => {
        const fetcher = useCallback(() => Promise.reject(new Error('error')), []);
        return useFetchData(fetcher);
      });

      await waitFor(() => {
        const { data, isLoading, isError } = result.current;
        expect(isLoading).toBe(false);
        expect(isError).toBe(true);
        expect(data).toBeNull();
      });
    });

    it('unmount test', async () => {
      const { result, unmount } = renderHook(() => {
        const fetcher = useCallback(() => Promise.reject(new Error('error')), []);
        return useFetchData(fetcher);
      });

      unmount();

      await waitFor(() => {
        const { data, isError } = result.current;
        expect(isError).toBe(false);
        expect(data).toBeNull();
      });
    });
  });
});
