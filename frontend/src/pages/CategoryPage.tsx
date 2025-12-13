import { useCallback } from 'react';
import Simpress from '../api/Simpress';
import { MyClipLoader, NotFound, PostList } from '../components';
import { useCategory, useFetchData } from '../hooks';
import type { PostType } from '../types';

const CategoryPage = (): React.JSX.Element => {
  const category = useCategory();

  const fetcher = useCallback(() => {
    if (category === null) {
      throw new Error('category is null');
    }

    return Simpress.getPostsByCategory(category);
  }, [category]);

  const { data: posts, isError } = useFetchData<PostType[]>(fetcher);

  if (isError) {
    return <NotFound />;
  }

  if (posts === null) {
    return <MyClipLoader />;
  }

  return <PostList posts={posts} />;
};

export default CategoryPage;
