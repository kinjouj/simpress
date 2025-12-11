import { useEffect, useReducer } from 'react';
import { fetchReducer } from '../reducers/fetchReducer';
import type { FetchState } from '../types';

export const useFetchData = <T>(fetcher: () => Promise<T>): FetchState<T> => {
  const [state, dispatch] = useReducer(fetchReducer<T>, { data: null, isError: false });

  useEffect(() => {
    let cancelled = false;

    const fetchData = async (): Promise<void> => {
      try {
        dispatch({ type: 'FETCH_START' });
        const data = await fetcher();

        if (!cancelled) {
          dispatch({ type: 'FETCH_COMPLETE', payload: data });
        }
      } catch {
        if (!cancelled) {
          dispatch({ type: 'FETCH_ERROR' });
        }
      }
    };
    void fetchData();

    return (): void => {
      cancelled = true;
    };
  }, [fetcher]);

  return state;
};
