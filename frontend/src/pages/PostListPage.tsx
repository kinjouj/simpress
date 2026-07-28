import React, { Suspense, useCallback, useLayoutEffect } from 'react';
import { NavigationType, useNavigationType } from 'react-router';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, PostList } from '../components';
import { PaginateProvider, usePaginateContext } from '../contexts/PaginateContext';
import { useFetchData, useFetchPageMeta, usePage } from '../hooks';
import type { PostType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/PostListSkeleton'));

const PostListPage = (): React.JSX.Element | null => {
  const page = usePage();
  const { totalPages, isLoading, isOutOfPage } = useFetchPageMeta('/archives/page');

  if (isOutOfPage(page)) {
    return <NotFound />;
  }

  if (isLoading || totalPages === null) {
    return <div>loading...</div>;
  }

  return (
    <PaginateProvider value={{ page: page, totalPages: totalPages }}>
      <PostListPageContent />
    </PaginateProvider>
  );
};

const PostListPageContent = (): React.JSX.Element => {
  const { page }: { page: number } = usePaginateContext();
  const navigationType = useNavigationType();
  const postListFetcher = useCallback(async () => {
    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getPostsByPage(page);
  }, [page]);

  const { data: posts, isError } = useFetchData<PostType[]>(postListFetcher);

  useLayoutEffect(() => {
    if (navigationType === NavigationType.Pop) {
      return;
    }

    window.scrollTo(0, 0);
  }, [page, navigationType]);

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
    <div>
      <PostList posts={posts} />
      <Paginator basePath="/page" />
    </div>
  );
};

export default PostListPage;
