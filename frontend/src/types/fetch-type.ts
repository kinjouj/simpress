export type FetchAction<T> = { type: 'FETCH_START' } | { type: 'FETCH_COMPLETE', payload: T } | { type: 'FETCH_ERROR' };
export type FetchState<T> = {
  data: T | null
  isError: boolean
};
