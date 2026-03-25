import { useCallback } from 'react';
import Simpress from '../api/Simpress';
import { useFetchData } from './useFetchData';

export const useFetchPageMeta = (path: string | null): { totalPages: number | null, isOutOfPage: (currentPage: number) => boolean } => {
  const fetcher = useCallback(() => {
    if (path === null) {
      return Promise.resolve(null);
    }

    return Simpress.getMeta(path);
  }, [path]);

  const { data: totalPages } = useFetchData(fetcher);
  const isOutOfPage = useCallback((currentPage: number) => {
    if (totalPages === null) {
      return false;
    }

    return totalPages < currentPage;
  }, [totalPages]);

  return { totalPages: totalPages, isOutOfPage };
};
