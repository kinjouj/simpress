import { useCallback, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Prism from 'prismjs';
import Simpress from '../api/Simpress';
import { CreatedAt, MyClipLoader, NotFound } from '../components';
import { useFetchData, usePermalink } from '../hooks';
import type { CategoryType, PostType } from '../types';
import 'prismjs/plugins/autoloader/prism-autoloader';
import 'prismjs/plugins/line-numbers/prism-line-numbers';

(Prism as any).plugins.autoloader.languages_path = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/';

const PostPage = (): React.JSX.Element => {
  const permalink = usePermalink();

  const fetcher = useCallback(() => {
    if (permalink === null) {
      throw new Error('permalink is null');
    }

    return Simpress.getPost(permalink);
  }, [permalink]);

  const { data: post, isError } = useFetchData<PostType>(fetcher);

  useEffect(() => {
    Prism.highlightAll();
  }, [post]);

  if (isError) {
    return <NotFound />;
  }

  if (post === null) {
    return <MyClipLoader />;
  }

  return (
    <div className="container mt-5 flex-grow-1">
      <div className="row g-0">
        <div className="col col-lg-12"></div>
        <div className="col col-lg-8">
          <div id="content">
            <div className="post" role="main">
              <div className="post-date">
                <CreatedAt dateString={post.date} />
              </div>
              <h1>{post.title}</h1>
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
              <div style={{ marginTop: '30px' }}>
                <hr />
                <pre><code className="language-json">{JSON.stringify(post, null, 2)}</code></pre>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PostPage;
