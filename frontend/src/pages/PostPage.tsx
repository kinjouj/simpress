import React, { Suspense, useCallback, useEffect } from 'react';
import { Col, Row, Stack } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import Prism from 'prismjs';
import Simpress from '../api/Simpress';
import { CreatedAt, NotFound, RecentPosts, RelatedPosts } from '../components';
import { useFetchData, usePermalink } from '../hooks';
import { type CategoryType, type PostType } from '../types';
import 'prismjs/themes/prism-tomorrow.css';
import 'prismjs/plugins/autoloader/prism-autoloader';
import 'prismjs/plugins/line-numbers/prism-line-numbers';
import 'prismjs/plugins/line-numbers/prism-line-numbers.css';

// eslint-disable-next-line
(Prism as any).plugins.autoloader.languages_path = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/';

const LazyPostPageSkeleton = React.lazy(() => import('../components/Skeleton/PostPageSkeleton'));

const PostPage = (): React.JSX.Element => {
  const permalink = usePermalink();

  const fetcher = useCallback(async () => {
    if (permalink === null) {
      throw new Error('permalink is null');
    }

    await new Promise((r) => setTimeout(r, 3000));

    return Simpress.getPost(permalink);
  }, [permalink]);

  const { data: post, isError } = useFetchData<PostType>(fetcher);

  useEffect(() => {
    if (post === null) {
      return;
    }

    requestAnimationFrame(() => {
      /* istanbul ignore next */
      Prism.highlightAll();
    });
  }, [post]);

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
    <Row className="g-0">
      <Col lg={7}>
        <article className="post" role="main">
          <div className="post-date fs-4 fw-bold my-2">
            <CreatedAt dateString={post.date} />
          </div>
          <h1 className="post-title fs-3 fw-bold my-3">{post.title}</h1>
          <hr />
          <Stack direction="horizontal" gap={3} className="post-categories position-relative m-0">
            {post.categories.map((category: CategoryType) => {
              const to = `/archives/category/${category.key}`;
              return <Link key={category.key} to={to} className="fs-5">{category.name}</Link>;
            })}
          </Stack>
          <div dangerouslySetInnerHTML={{ __html: post.content }} className="post-content fs-6 my-4 mw-100" />
          {!!post.similarities && <RelatedPosts similarities={post.similarities} />}
          <div style={{ marginTop: '30px' }}>
            <hr />
            <pre className="line-numbers"><code className="language-json">{JSON.stringify(post, null, 2)}</code></pre>
          </div>
        </article>
      </Col>
      <Col xs={12} lg={4} className="ms-auto ps-5">
        <aside className="sidebar">
          <div id="recent_posts">
            <h4>Recent Posts</h4>
            <RecentPosts />
          </div>
        </aside>
      </Col>
    </Row>
  );
};

export default PostPage;
