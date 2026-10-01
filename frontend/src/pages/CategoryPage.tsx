import React, { Suspense, useCallback, useLayoutEffect } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, EntryList } from '../components';
import { PaginateProvider } from '../contexts/PaginateContext';
import { useCategory, useFetchData, usePage } from '../hooks';

const LazyEntryListSkeleton = React.lazy(() => import('../components/EntryListSkeleton'));

const CategoryPage = (): React.JSX.Element => {
  const category = useCategory();
  const page = usePage();
  const fetcher = useCallback(async () => {
    if (category === null) {
      return null;
    }

    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getEntriesByCategory(category, page);
  }, [category, page]);

  const { data, isError, isLoading } = useFetchData(fetcher);

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
        <LazyEntryListSkeleton />
      </Suspense>
    );
  }

  return (
    <PaginateProvider value={{ page, totalPages: data.total_pages }}>
      <EntryList entries={data.entries} />
      <Paginator basePath={`/archives/categories/${category}`} />
    </PaginateProvider>
  );
};

export default CategoryPage;
