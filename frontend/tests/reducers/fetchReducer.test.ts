import { fetchReducer } from '../../src/reducers/fetchReducer';
import { testEntryData } from '../fixtures/testEntryData';
import type { EntryType } from '../../src/types';

describe('fetchReducer', () => {
  it('各アクションに応じて状態を更新する', () => {
    const stateDefault = fetchReducer<null>(
      { data: null, isLoading: false, isError: false },
      { type: 'FETCH_DEFAULT' } as any // eslint-disable-line
    );
    expect(stateDefault.data).toBeNull();
    expect(stateDefault.isLoading).toBe(false);
    expect(stateDefault.isError).toBe(true);

    const stateStart = fetchReducer<EntryType>(
      { data: null, isLoading: false, isError: true },
      { type: 'FETCH_START' }
    );
    expect(stateStart.isLoading).toBe(true);
    expect(stateStart.isError).toBe(false);
    expect(stateStart.data).toBeNull();

    const stateComplete = fetchReducer<EntryType>(
      { data: null, isLoading: true, isError: true },
      { type: 'FETCH_COMPLETE', payload: testEntryData }
    );
    expect(stateComplete.data).not.toBeNull();
    expect(stateComplete.isLoading).toBe(false);
    expect(stateComplete.isError).toBe(false);

    const stateError = fetchReducer(
      { data: null, isLoading: true, isError: false },
      { type: 'FETCH_ERROR' }
    );
    expect(stateError.data).toBeNull();
    expect(stateError.isLoading).toBe(false);
    expect(stateError.isError).toBe(true);
  });
});
