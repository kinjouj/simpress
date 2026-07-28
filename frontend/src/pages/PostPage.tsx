import React, { Suspense, useCallback, useEffect, useLayoutEffect } from 'react';
import { useLocation } from 'react-router';
import Prism from 'prismjs';
import Simpress from '../api/Simpress';
import { AdjacentPosts, CreatedAt, NotFound, PostCategories, RelatedPosts, TableOfContents } from '../components';
import { useFetchData, usePermalink } from '../hooks';
import type { PostType } from '../types';

import 'prismjs/themes/prism-tomorrow.css';
import 'prismjs/plugins/autoloader/prism-autoloader';
import 'prismjs/plugins/line-numbers/prism-line-numbers';
import 'prismjs/plugins/line-numbers/prism-line-numbers.css';

Prism.plugins.autoloader.languages_path = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/'; // eslint-disable-line

const LazyPostPageSkeleton = React.lazy(() => import('../components/PostPageSkeleton'));

const PostPage = (): React.JSX.Element => {
  const location = useLocation();
  const permalink = usePermalink();

  const fetcher = useCallback(async () => {
    if (permalink === null) {
      throw new Error('permalink is null');
    }

    await new Promise((r) => setTimeout(r, 3000));

    return Simpress.getPost(permalink);
  }, [permalink]);

  const { data: post, isError } = useFetchData<PostType>(fetcher);

  useLayoutEffect(() => {
    if (post === null) {
      return;
    }

    window.scrollTo(0, 0);
  }, [post]);

  useEffect(() => {
    if (post === null) {
      return;
    }

    requestAnimationFrame(() => {
      /* istanbul ignore next */
      Prism.highlightAll();
    });
  }, [post, location.key]);

  if (isError) {
    return <NotFound />;
  }

  if (post === null) {
    return (
      <Suspense fallback={<div>loading...</div>}>
        <LazyPostPageSkeleton />
      </Suspense>
    );
  }

  return (
    <article className="post">
      <div className="post-date fs-4 fw-bold my-2">
        <CreatedAt dateString={post.date} />
      </div>
      <h1 className="post-title fs-3 fw-bold my-3">{post.title}</h1>
      <hr />
      <PostCategories taxonomies={post.taxonomies} className="post-categories position-relative m-0" />
      <div dangerouslySetInnerHTML={{ __html: post.content ?? '' }} className="post-content fs-6 my-4 mw-100" />
      <TableOfContents toc={post.toc} />
      {(!!post.prev || !!post.next) && <AdjacentPosts next={post.next} prev={post.prev} />}
      {!!post.similarities && post.similarities.length > 0 && <RelatedPosts similarities={post.similarities} />}
      <div style={{ marginTop: '30px' }}>
        <pre className="line-numbers"><code className="language-json">{JSON.stringify(post, null, 2)}</code></pre>
      </div>
    </article>
  );
};

export default PostPage;
