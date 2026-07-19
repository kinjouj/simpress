import React, { Suspense, useCallback, useLayoutEffect } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, PostList } from '../components';
import { PaginateProvider, usePaginateContext } from '../contexts/PaginateContext';
import { useCategory, useFetchData, useFetchPageMeta, usePage } from '../hooks';
import type { PostType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/PostListSkeleton'));

const CategoryPage = (): React.JSX.Element | null => {
  const category = useCategory();
  const page = usePage();
  const { totalPages, isLoading, isOutOfPage } = useFetchPageMeta(`/archives/categories/${category}`);

  useLayoutEffect(() => {
    if (category === null) {
      return;
    }

    window.scrollTo(0, 0);
  }, [category, page]);

  if (category === null || isOutOfPage(page)) {
    return <NotFound />;
  }

  if (isLoading || totalPages === null) {
    return <div>loading...</div>;
  }

  return (
    <PaginateProvider value={{ page, totalPages }}>
      <CategoryPageContent category={category} />
    </PaginateProvider>
  );
};

const CategoryPageContent = ({ category }: { category: string }): React.JSX.Element => {
  const { page } = usePaginateContext();

  const fetcher = useCallback(async () => {
    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getPostsByCategory(category, page);
  }, [category, page]);

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
    <div>
      <PostList posts={posts} />
      <Paginator basePath={`/archives/categories/${category}`} />
    </div>
  );
};

export default CategoryPage;
