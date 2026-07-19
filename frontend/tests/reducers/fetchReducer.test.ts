import { fetchReducer } from '../../src/reducers/fetchReducer';
import { testPostData } from '../fixtures/testPostData';
import type { PostType } from '../../src/types';

describe('fetchReducer', () => {
  test('fetchReducer test', () => {
    const stateDefault = fetchReducer<null>(
      { data: null, isLoading: false, isError: false },
      { type: 'FETCH_DEFAULT' } as any // eslint-disable-line
    );
    expect(stateDefault.data).toBeNull();
    expect(stateDefault.isLoading).toBeFalsy();
    expect(stateDefault.isError).toBeTruthy();

    const stateStart = fetchReducer<PostType>(
      { data: null, isLoading: false, isError: true },
      { type: 'FETCH_START' }
    );
    expect(stateStart.isLoading).toBeTruthy();
    expect(stateStart.isError).toBeFalsy();
    expect(stateStart.data).toBeNull();

    const stateComplete = fetchReducer<PostType>(
      { data: null, isLoading: true, isError: true },
      { type: 'FETCH_COMPLETE', payload: testPostData }
    );
    expect(stateComplete.data).not.toBeNull();
    expect(stateComplete.isLoading).toBeFalsy();
    expect(stateComplete.isError).toBeFalsy();

    const stateError = fetchReducer(
      { data: null, isLoading: true, isError: false },
      { type: 'FETCH_ERROR' }
    );
    expect(stateError.data).toBeNull();
    expect(stateError.isLoading).toBeFalsy();
    expect(stateError.isError).toBeTruthy();
  });
});
