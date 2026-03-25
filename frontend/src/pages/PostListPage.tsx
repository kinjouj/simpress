import React, { Suspense, useCallback } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, PostList } from '../components';
import { PaginateProvider, usePaginateContext } from '../contexts/PagenateContext';
import { useFetchData, useFetchPageMeta, usePage } from '../hooks';
import type { PostType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/Skeleton/PostListSkeleton'));

const PostListPage = (): React.JSX.Element | null => {
  const page = usePage();
  const { totalPages, isOutOfPage } = useFetchPageMeta('/archives/page');

  if (isOutOfPage(page)) {
    return <NotFound />;
  }

  if (totalPages === null) {
    return null;
  }

  return (
    <PaginateProvider value={{ page: page, totalPages: totalPages }}>
      <PostListPageContent />
    </PaginateProvider>
  );
};

const PostListPageContent = (): React.JSX.Element => {
  const { page }: { page: number } = usePaginateContext();
  const postListFetcher = useCallback(async () => {
    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getPostsByPage(page);
  }, [page]);

  const { data: posts, isError } = useFetchData<PostType[]>(postListFetcher);

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
