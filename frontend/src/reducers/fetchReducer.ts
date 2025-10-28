import type { FetchAction, FetchState } from '../types';

export const fetchReducer = <T>(state: FetchState<T>, action: FetchAction<T>): FetchState<T> => {
  switch (action.type) {
    case 'FETCH_START':
      return {
        ...state,
        data: null,
        isError: false,
      };

    case 'FETCH_COMPLETE':
      return {
        ...state,
        data: action.payload,
        isError: false,
      };

    case 'FETCH_ERROR':
      return {
        ...state,
        data: null,
        isError: true,
      };

    default:
      return {
        ...state,
        data: null,
        isError: true,
      };
  }
};
