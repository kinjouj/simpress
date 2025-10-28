import { useEffect, useReducer } from 'react';
import Simpress from '../api/Simpress';
import { MyClipLoader, NotFound, PostList } from '../components';
import { useCategory } from '../hooks';
import { fetchReducer } from '../reducers';
import type { FetchState, PostType } from '../types';

const CategoryPage = (): React.JSX.Element => {
  const category = useCategory();
  const [state, dispatch] = useReducer(fetchReducer<PostType[]>, { data: null, isError: false } as FetchState<PostType[]>);
  const { data: categoryPosts, isError } = state;

  useEffect(() => {
    dispatch({ type: 'FETCH_START' });

    if (category === null) {
      dispatch({ type: 'FETCH_ERROR' });
      return;
    }

    void (async (): Promise<void> => {
      try {
        const categoryPosts = await Simpress.getPostsByCategory(category);
        setTimeout(() => {
          dispatch({ type: 'FETCH_COMPLETE', payload: categoryPosts });
        }, 1000);
      } catch {
        dispatch({ type: 'FETCH_ERROR' });
      }
    })();
  }, [category]);

  if (isError) {
    return <NotFound />;
  }

  if (categoryPosts === null) {
    return <MyClipLoader />;
  }

  return <PostList posts={categoryPosts} />;
};

export default CategoryPage;
