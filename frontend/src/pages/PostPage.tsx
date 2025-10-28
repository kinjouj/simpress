import { useEffect, useReducer } from 'react';
import { Link } from 'react-router-dom';
import Prism from 'prismjs';
import Simpress from '../api/Simpress';
import { CreatedAt, MyClipLoader, NotFound } from '../components';
import { usePermalink } from '../hooks';
import { fetchReducer } from '../reducers';
import type { CategoryType, FetchState, PostType } from '../types';
import 'prismjs/plugins/line-numbers/prism-line-numbers';

const PostPage = (): React.JSX.Element => {
  const permalink = usePermalink();
  const [state, dispatch] = useReducer(fetchReducer<PostType>, { data: null, isError: false } as FetchState<PostType>);
  const { data: post, isError } = state;

  useEffect(() => {
    dispatch({ type: 'FETCH_START' });

    if (permalink === null) {
      dispatch({ type: 'FETCH_ERROR' });
      return;
    }

    void (async (): Promise<void> => {
      try {
        const post = await Simpress.getPost(permalink);
        setTimeout(() => {
          dispatch({ type: 'FETCH_COMPLETE', payload: post });
          setTimeout(Prism.highlightAll, 500);
        }, 1000);
      } catch {
        dispatch({ type: 'FETCH_ERROR' });
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

export default PostPage;
