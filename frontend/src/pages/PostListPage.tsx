import React, { Suspense, useCallback } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, Pager, PostList } from '../components';
import { useFetchData, usePage } from '../hooks';
import type { PostType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/Skeleton/PostListSkeleton'));

const PostListPage = (): React.JSX.Element => {
  const pageNum = usePage();

  const fetcher = useCallback(async () => {
    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getPostsByPage(pageNum);
  }, [pageNum]);

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

  return (
    <>
      <PostList posts={posts} />
      <Pager />
    </>
  );
};

export default PostListPage;
