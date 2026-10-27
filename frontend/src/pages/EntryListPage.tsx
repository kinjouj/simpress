import React, { Suspense, useCallback, useLayoutEffect } from 'react';
import { NavigationType, useNavigationType } from 'react-router';
import Simpress from '../api/Simpress';
import { NotFound, Paginator, EntryList } from '../components';
import { PaginateProvider } from '../contexts/PaginateContext';
import { useFetchData, usePage } from '../hooks';

const LazyEntryListSkeleton = React.lazy(() => import('../components/EntryListSkeleton'));

const EntryListPage = (): React.JSX.Element => {
  const page = usePage();
  const navigationType = useNavigationType();
  const fetcher = useCallback(async () => {
    await new Promise((r) => setTimeout(r, 3000));
    return Simpress.getEntriesByPage(page);
  }, [page]);

  const { data, isError } = useFetchData(fetcher);

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
        <LazyEntryListSkeleton />
      </Suspense>
    );
  }

  return (
    <PaginateProvider value={{ page, totalPages: data.total_pages }}>
      <EntryList entries={data.entries} />
      <Paginator basePath="/page" />
    </PaginateProvider>
  );
};

export default EntryListPage;
