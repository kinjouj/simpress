import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Prism from 'prismjs';
import Simpress from '../simpress';
import CreatedAt from '../components/CreatedAt';
import MyClipLoader from '../components/MyClipLoader';
import NotFound from '../components/NotFound';
import { usePermalink } from '../hooks';
import type { PostType, CategoryType } from '../types';
import 'prismjs/plugins/line-numbers/prism-line-numbers';

const Post = (): React.JSX.Element => {
  const permalink = usePermalink();
  const [post, setPost] = useState<PostType | null>(null);
  const [isError, setIsError] = useState(false);

  useEffect(() => {
    ((): void => {
      setPost(null);
      setIsError(false);
    })();

    const setErrorState = (): void => {
      setPost(null);
      setIsError(true);
    };

    if (permalink === null) {
      setErrorState();
      return;
    }

    void (async (): Promise<void> => {
      try {
        const post = await Simpress.getPost(permalink);
        setTimeout(() => {
          setPost(post);
          setIsError(false);
          setTimeout(Prism.highlightAll, 500);
        }, 1000);
      } catch {
        setErrorState();
      }
    })();
  }, [permalink]);

  if (isError) {
    return <NotFound />;
  }

  if (post === null) {
    return <MyClipLoader />;
  }

  return (
    <div className="container mt-5">
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
                    return <Link className="post-category" key={category.key} to={to}>{category.name}</Link>;
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

export default Post;
