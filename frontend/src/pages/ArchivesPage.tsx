import React, { Suspense, useCallback } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, PostList } from '../components';
import { useFetchData, useYearOfMonth } from '../hooks';
import type { PostType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/Skeleton/PostListSkeleton'));

const ArchivesPage = (): React.JSX.Element => {
  const { year, month } = useYearOfMonth();

  const fetcher = useCallback(async () => {
    if (year === null || month === null) {
      throw new Error('year|month is null');
    }

    await new Promise((r) => setTimeout(r, 3000));

    return Simpress.getPostsByArchive(year, month);
  }, [year, month]);

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

export default ArchivesPage;
