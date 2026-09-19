import React, { Suspense, useCallback, useLayoutEffect } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, PostList } from '../components';
import { PaginateProvider } from '../contexts/PaginateContext';
import { useCategory, useFetchData, usePage } from '../hooks';
import type { PagedPostsType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/PostListSkeleton'));

const CategoryPage = (): React.JSX.Element => {
  const category = useCategory();
  const page = usePage();
  const fetcher = useCallback(async () => {
    if (category === null) {
      return null;
    }

    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getPostsByCategory(category, page);
  }, [category, page]);

  const { data, isError, isLoading } = useFetchData<PagedPostsType | null>(fetcher);

  useLayoutEffect(() => {
    if (category === null) {
      return;
    }

    window.scrollTo(0, 0);
  }, [category, page]);

  if (category === null || isError) {
    return <NotFound />;
  }

  if (isLoading || data === null) {
    return (
      <Suspense fallback={<div>loading...</div>}>
        <LazyPostListSkeleton />
      </Suspense>
    );
  }

  return (
    <PaginateProvider value={{ page, totalPages: data.total_pages }}>
      <PostList posts={data.posts} />
      <Paginator basePath={`/archives/categories/${category}`} />
    </PaginateProvider>
  );
};

export default CategoryPage;
