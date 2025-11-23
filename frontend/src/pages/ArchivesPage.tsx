import { useEffect, useReducer } from 'react';
import Simpress from '../api/simpress';
import { MyClipLoader, NotFound, PostList } from '../components';
import { useYearOfMonth } from '../hooks';
import { fetchReducer } from '../reducers';
import type { FetchState, PostType } from '../types';

const ArchivesPage = (): React.JSX.Element => {
  const { year, month } = useYearOfMonth();
  const [ state, dispatch ] = useReducer(fetchReducer<PostType[]>, { data: null, isError: false } as FetchState<PostType[]>);
  const { data: posts, isError } = state;

  useEffect(() => {
    dispatch({ type: 'FETCH_START' });

    if (year === null || month === null) {
      dispatch({ type: 'FETCH_ERROR' });
      return;
    }

    void (async (): Promise<void> => {
      try {
        const posts = await Simpress.getPostsByArchive(year, month);
        setTimeout(() => {
          dispatch({ type: 'FETCH_COMPLETE', payload: posts });
        }, 1000);
      } catch {
        dispatch({ type: 'FETCH_ERROR' });
      }
    })();
  }, [ year, month ]);

  if (isError) {
    return <NotFound />;
  }

  if (posts === null) {
    return <MyClipLoader />;
  }

  return <PostList posts={posts} />;
};

export default ArchivesPage;
