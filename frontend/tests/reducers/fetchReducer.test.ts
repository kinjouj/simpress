import { fetchReducer } from '../../src/reducers';
import { testPostData } from '../fixtures/testPostData';
import type { PostType } from '../../src/types';

describe('fetchReducer', () => {
  test('fetchReducer test', () => {
    const stateDefault = fetchReducer<null>({ data: null, isError: false }, { type: 'FETCH_DEFAULT' } as any); // eslint-disable-line
    expect(stateDefault.data).toBeNull();
    expect(stateDefault.isError).toBeTruthy();

    const stateStart = fetchReducer<PostType>({ data: null, isError: true }, { type: 'FETCH_START' });
    expect(stateStart.isError).toBeFalsy();
    expect(stateStart.data).toBeNull();

    const stateComplete = fetchReducer<PostType>(
      { data: null, isError: true },
      { type: 'FETCH_COMPLETE', payload: testPostData }
    );
    expect(stateComplete.data).not.toBeNull();
    expect(stateComplete.isError).toBeFalsy();

    const stateError = fetchReducer({ data: null, isError: false }, { type: 'FETCH_ERROR' });
    expect(stateError.data).toBeNull();
    expect(stateError.isError).toBeTruthy();
  });
});
