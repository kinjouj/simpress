import React, { Suspense, useCallback, useLayoutEffect } from 'react';
import { NavigationType, useNavigationType } from 'react-router';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, PostList } from '../components';
import { PaginateProvider } from '../contexts/PaginateContext';
import { useFetchData, usePage } from '../hooks';
import type { PagedPostsType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/PostListSkeleton'));

const PostListPage = (): React.JSX.Element => {
  const page = usePage();
  const navigationType = useNavigationType();
  const fetcher = useCallback(async () => {
    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getPostsByPage(page);
  }, [page]);

  const { data, isError } = useFetchData<PagedPostsType>(fetcher);

  useLayoutEffect(() => {
    if (data === null) {
      return;
    }

    if (navigationType === NavigationType.Pop) {
      return;
    }

    window.scrollTo(0, 0);
  }, [data, page, navigationType]);

  if (isError) {
    return <NotFound />;
  }

  if (data === null) {
    return (
      <Suspense fallback={<div>loading...</div>}>
        <LazyPostListSkeleton />
      </Suspense>
    );
  }

  return (
    <PaginateProvider value={{ page, totalPages: data.total_pages }}>
      <PostList posts={data.posts} />
      <Paginator basePath="/page" />
    </PaginateProvider>
  );
};

export default PostListPage;
