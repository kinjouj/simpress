import { fetchReducer } from '../../src/reducers/fetchReducer';
import { testEntryData } from '../fixtures/testEntryData';
import type { EntryType } from '../../src/types';

describe('fetchReducer', () => {
  it('starts loading on FETCH_START', () => {
    const state = fetchReducer<EntryType>({ data: null, isLoading: false, isError: true }, { type: 'FETCH_START' });
    expect(state.isLoading).toBe(true);
    expect(state.isError).toBe(false);
    expect(state.data).toBeNull();
  });

  it('stores data on FETCH_COMPLETE', () => {
    const state = fetchReducer<EntryType>({ data: null, isLoading: true, isError: true }, { type: 'FETCH_COMPLETE', payload: testEntryData });
    expect(state.data).toEqual(testEntryData);
    expect(state.isLoading).toBe(false);
    expect(state.isError).toBe(false);
  });

  it('sets the error on FETCH_ERROR', () => {
    const state = fetchReducer({ data: null, isLoading: true, isError: false }, { type: 'FETCH_ERROR' });
    expect(state.data).toBeNull();
    expect(state.isLoading).toBe(false);
    expect(state.isError).toBe(true);
  });
});
