import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Simpress from '../simpress';
import CreatedAt from '../components/CreatedAt';
import MyClipLoader from '../components/MyClipLoader';
import NotFound from '../components/NotFound';
import { usePermalink } from '../hooks';
import type { PostType, CategoryType } from '../types';

const Post = (): React.JSX.Element => {
  const permalink = usePermalink();
  const [post, setPost] = useState<PostType | null>(null);
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    ((): void => {
      setPost(null);
      setIsLoading(true);
      setIsError(false);
    })();

    const setErrorState = (): void => {
      setIsLoading(false);
      setIsError(true);
    };

    if (permalink === null) {
      setErrorState();
      return;
    }

    Simpress.getPost(permalink).then((data) => {
      setPost(data);
      setIsLoading(false);
      setIsError(false);
    }).catch(() => {
      setErrorState();
    });
  }, [permalink]);

  if (isError) return <NotFound />;
  if (isLoading || post === null) return <MyClipLoader loading={isLoading} />;

  return (
    <div className="container mt-5">
      <div className="row g-0">
        <div className="col col-lg-12"></div>
        <div className="col col-lg-8">
          <div id="content">
            <div className="post">
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
              <div className="post-content" dangerouslySetInnerHTML={{ __html: post.content }} />
              <div style={{ marginTop: '30px' }}>
                <hr />
                <pre>{JSON.stringify(post, null, 2)}</pre>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Post;
