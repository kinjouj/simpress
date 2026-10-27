export type FetchState<T> = {
  data: T | null
  isLoading: boolean
  isError: boolean
};
