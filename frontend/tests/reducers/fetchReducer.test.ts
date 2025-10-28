import { fetchReducer } from '../../src/reducers';
import { testPostData } from '../fixtures/testPostData';
import type { PostType } from '../../src/types';

describe('fetchReducer', () => {
  test('fetchReducer test', () => {
    /* eslint-disable */
    const state_default = fetchReducer<null>({ data: null, isError: false }, { type: 'FETCH_DEFAULT' } as any);
    /* eslint-enable */
    expect(state_default.data).toBeNull();
    expect(state_default.isError).toBeTruthy();

    const state_start = fetchReducer<PostType>({ data: null, isError: true }, { type: 'FETCH_START' });
    expect(state_start.isError).toBeFalsy();
    expect(state_start.data).toBeNull();

    const state_complete = fetchReducer<PostType>(
      { data: null, isError: true },
      { type: 'FETCH_COMPLETE', payload: testPostData }
    );
    expect(state_complete.data).not.toBeNull();
    expect(state_complete.isError).toBeFalsy();

    const state_error = fetchReducer({ data: null, isError: false }, { type: 'FETCH_ERROR' });
    expect(state_error.data).toBeNull();
    expect(state_error.isError).toBeTruthy();
  });
});
