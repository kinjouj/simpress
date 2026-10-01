import React, { Suspense, useCallback, useEffect, useLayoutEffect } from 'react';
import { useLocation } from 'react-router';
import Prism from 'prismjs';
import Simpress from '../api/Simpress';
import { AdjacentEntries, CreatedAt, NotFound, EntryCategories, RelatedEntries, TableOfContents } from '../components';
import { useFetchData, usePermalink } from '../hooks';

import 'prismjs/themes/prism-tomorrow.css';
import 'prismjs/plugins/autoloader/prism-autoloader';
import 'prismjs/plugins/line-numbers/prism-line-numbers';
import 'prismjs/plugins/line-numbers/prism-line-numbers.css';

Prism.plugins.autoloader.languages_path = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/'; // eslint-disable-line

const LazyEntryPageSkeleton = React.lazy(() => import('../components/EntryPageSkeleton'));

const EntryPage = (): React.JSX.Element => {
  const location = useLocation();
  const permalink = usePermalink();

  const fetcher = useCallback(async () => {
    if (permalink === null) {
      throw new Error('permalink is null');
    }

    await new Promise((r) => setTimeout(r, 3000));

    return Simpress.getEntry(permalink);
  }, [permalink]);

  const { data: entry, isError } = useFetchData(fetcher);

  useLayoutEffect(() => {
    if (entry === null) {
      return;
    }

    window.scrollTo(0, 0);
  }, [entry]);

  useEffect(() => {
    if (entry === null) {
      return;
    }

    requestAnimationFrame(() => {
      /* istanbul ignore next */
      Prism.highlightAll();
    });
  }, [entry, location.key]);

  if (isError) {
    return <NotFound />;
  }

  if (entry === null) {
    return (
      <Suspense fallback={<div>loading...</div>}>
        <LazyEntryPageSkeleton />
      </Suspense>
    );
  }

  return (
    <article className="entry">
      <div className="entry-date fs-4 fw-bold my-2">
        <CreatedAt dateString={entry.date} />
      </div>
      <h1 className="entry-title fs-3 fw-bold my-3">{entry.title}</h1>
      <hr />
      <EntryCategories taxonomies={entry.taxonomies} className="entry-categories position-relative m-0" />
      <div dangerouslySetInnerHTML={{ __html: entry.content ?? '' }} className="entry-content fs-6 my-4 mw-100" />
      <TableOfContents toc={entry.toc} />
      {(!!entry.prev || !!entry.next) && <AdjacentEntries next={entry.next} prev={entry.prev} />}
      {!!entry.similarities && entry.similarities.length > 0 && <RelatedEntries similarities={entry.similarities} />}
      <div style={{ marginTop: '30px' }}>
        <pre className="line-numbers"><code className="language-json">{JSON.stringify(entry, null, 2)}</code></pre>
      </div>
    </article>
  );
};

export default EntryPage;
