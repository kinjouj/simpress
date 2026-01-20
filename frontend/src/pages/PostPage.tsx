import React, { Suspense, useCallback, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Prism from 'prismjs';
import Simpress from '../api/Simpress';
import { CreatedAt, NotFound, RecentPosts, Similarity } from '../components';
import { useFetchData, usePermalink } from '../hooks';
import { type CategoryType, type PostType } from '../types';
import 'prismjs/plugins/autoloader/prism-autoloader';
import 'prismjs/plugins/line-numbers/prism-line-numbers';

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
    <div className="container">
      <div className="row">
        <div className="col col-lg-8">
          <div id="content" className="m-4 mb-5">
            <div className="post" role="main">
              <div className="post-date">
                <CreatedAt dateString={post.date} />
              </div>
              <h1 className="post-title">{post.title}</h1>
              <hr />
              <p className="meta">
                <span className="categories">
                  {post.categories.map((category: CategoryType) => {
                    const to = `/archives/category/${category.key}`;
                    return <Link key={category.key} className="post-category" to={to}>{category.name}</Link>;
                  })}
                </span>
              </p>
              <div className="post-content mw-100" dangerouslySetInnerHTML={{ __html: post.content }} />
              <Similarity post={post} />
              <div style={{ marginTop: '30px' }}>
                <hr />
                <pre><code className="language-json">{JSON.stringify(post, null, 2)}</code></pre>
              </div>
            </div>
          </div>
        </div>
        <div className="col col-lg-4 mt-4">
          <aside>
            <div id="recent_posts">
              <h4>Recent Posts</h4>
              <RecentPosts />
            </div>
          </aside>
        </div>
      </div>
    </div>
  );
};

export default PostPage;
