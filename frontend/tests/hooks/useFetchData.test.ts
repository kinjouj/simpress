import { act, useCallback } from 'react';
import { useFetchData } from '../../src/hooks';
import { PostType } from '../../src/types';
import { testPostData } from '../fixtures/testPostData';
import { renderHook } from '@testing-library/react';

describe('useFetchData', () => {
  describe('useFetchData test', () => {
    it('successful', async () => {
      const { result } = renderHook(() => {
        const fetcher = useCallback(() => Promise.resolve(testPostData), []);
        return useFetchData<PostType>(fetcher)
      });

      await act(async () => {
        await Promise.resolve();
      });

      const { data, isError } = result.current;
      expect(isError).toBeFalsy();
      expect(data?.title).toEqual('test1');
    });

    it('unmount test', async () => {
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
    it('successful', async () => {
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

    it('unmount test', async () => {
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
