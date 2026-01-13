import React, { Suspense, useCallback } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, PostList } from '../components';
import { useCategory, useFetchData } from '../hooks';
import type { PostType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/Skeleton/PostListSkeleton'));

const CategoryPage = (): React.JSX.Element => {
  const category = useCategory();

  const fetcher = useCallback(async () => {
    if (category === null) {
      throw new Error('category is null');
    }

    await new Promise((r) => setTimeout(r, 3000));

    return Simpress.getPostsByCategory(category);
  }, [category]);

  const { data: posts, isError } = useFetchData<PostType[]>(fetcher);

  if (isError) {
    return <NotFound />;
  }

  if (posts === null) {
    return (
      <Suspense fallback={<div>loading...</div>}>
        <LazyPostListSkeleton />
      </Suspense>
    );
  }

  return <PostList posts={posts} />;
};

export default CategoryPage;
