import { useEffect, useReducer } from 'react';
import Simpress from '../api/Simpress';
import { MyClipLoader, NotFound, Pager, PostList } from '../components';
import { usePage } from '../hooks';
import { fetchReducer } from '../reducers';
import type { FetchState, PostType } from '../types';

const PostListPage = (): React.JSX.Element => {
  const pageNum = usePage();
  const [state, dispatch] = useReducer(fetchReducer<PostType[]>, { data: null, isError: false } as FetchState<PostType[]>);
  const { data: posts, isError } = state;

  useEffect(() => {
    dispatch({ type: 'FETCH_START' });

    void (async (): Promise<void> => {
      try {
        const posts = await Simpress.getPostsByPage(pageNum);
        setTimeout(() => {
          dispatch({ type: 'FETCH_COMPLETE', payload: posts });
        }, 1000);
      } catch {
        dispatch({ type: 'FETCH_ERROR' });
      }
    })();
  }, [pageNum]);

  if (isError) {
    return <NotFound />;
  }

  if (posts === null) {
    return <MyClipLoader />;
  }

  return (
    <div className="container">
      <PostList posts={posts} />
      <Pager />
    </div>
  );
};

export default PostListPage;
