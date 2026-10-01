import React, { Suspense, useCallback, useLayoutEffect } from 'react';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, EntryList } from '../components';
import { PaginateProvider } from '../contexts/PaginateContext';
import { useFetchData, usePage, useYearOfMonth } from '../hooks';

const LazyEntryListSkeleton = React.lazy(() => import('../components/EntryListSkeleton'));

const ArchivesPage = (): React.JSX.Element => {
  const { year, month } = useYearOfMonth();
  const page = usePage();
  const fetcher = useCallback(async () => {
    if (year === null || month === null) {
      return null;
    }

    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getEntriesByArchive(year, month, page);
  }, [year, month, page]);

  const { data, isError, isLoading } = useFetchData(fetcher);

  useLayoutEffect(() => {
    if (data === null) {
      return;
    }

    requestAnimationFrame(() => {
      window.scrollTo(0, 0);
    });
  }, [data, page]);

  if (year === null || month === null || isError) {
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
      <Paginator basePath={`/archives/${year}/${month}`} />
    </PaginateProvider>
  );
};

export default ArchivesPage;
