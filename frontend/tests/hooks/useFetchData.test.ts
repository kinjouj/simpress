import { act, useCallback } from 'react';
import { renderHook } from '@testing-library/react';
import { useFetchData } from '../../src/hooks';
import { testPostData } from '../fixtures/testPostData';
import type { PostType } from '../../src/types';

describe('useFetchData', () => {
  describe('useFetchData test', () => {
    test('successful', async () => {
      const { result } = renderHook(() => {
        const fetcher = useCallback(() => Promise.resolve(testPostData), []);
        return useFetchData<PostType>(fetcher);
      });

      await act(async () => {
        await Promise.resolve();
      });

      const { data, isError } = result.current;
      expect(isError).toBeFalsy();
      expect(data?.title).toBe('test1');
    });

    test('unmount test', async () => {
      const { result, unmount } = renderHook(() => {
        const fetcher = useCallback(() => Promise.resolve(testPostData), []);
        return useFetchData<PostType>(fetcher);
      });

      unmount();

      await act(async () => {
        await Promise.resolve();
      });

      const { data, isError } = result.current;
      expect(data).toBeNull();
      expect(isError).toBeFalsy();
    });
  });

  describe('if fetcher throw error', () => {
    test('successful', async () => {
      const { result } = renderHook(() => {
        const fetcher = useCallback(() => Promise.reject(new Error('error')), []);
        return useFetchData<PostType>(fetcher);
      });

      await act(async () => {
        await Promise.resolve();
      });

      const { data, isError } = result.current;
      expect(isError).toBeTruthy();
      expect(data).toBeNull();
    });

    test('unmount test', async () => {
      const { result, unmount } = renderHook(() => {
        const fetcher = useCallback(() => Promise.reject(new Error('error')), []);
        return useFetchData<PostType>(fetcher);
      });

      unmount();

      await act(async () => {
        await Promise.resolve();
      });

      const { data, isError } = result.current;

      expect(isError).toBeFalsy();
      expect(data).toBeNull();
    });
  });
});
