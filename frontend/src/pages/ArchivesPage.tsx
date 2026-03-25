import React, { Suspense, useCallback } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, PostList } from '../components';
import { PaginateProvider, usePaginateContext } from '../contexts/PagenateContext';
import { useFetchData, useFetchPageMeta, usePage, useYearOfMonth } from '../hooks';
import type { PostType } from '../types';

const LazyPostListSkeleton = React.lazy(() => import('../components/Skeleton/PostListSkeleton'));

const ArchivesPage = (): React.JSX.Element | null => {
  const { year, month } = useYearOfMonth();
  const padMonth = month ? month.toString().padStart(2, '0') : null;
  const page = usePage();
  const path = year !== null && padMonth !== null ? `/archives/${year}/${padMonth}` : null;
  const { totalPages, isOutOfPage } = useFetchPageMeta(path);

  if (year === null || month === null || isOutOfPage(page)) {
    return <NotFound />;
  }

  if (totalPages === null) {
    return null;
  }

  return (
    <PaginateProvider value={{ page, totalPages }}>
      <ArchivesPageContent year={year} month={month} />
    </PaginateProvider>
  );
};

const ArchivesPageContent = ({ year, month }: { year: number, month: number }): React.JSX.Element => {
  const { page } = usePaginateContext();

  const fetcher = useCallback(async () => {
    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getPostsByArchive(year, month, page);
  }, [year, month, page]);

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
      <Paginator basePath={`/archives/${year}/${month}`} />
    </div>
  );
};

export default ArchivesPage;
