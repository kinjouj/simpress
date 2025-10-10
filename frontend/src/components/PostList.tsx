import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Simpress from '../simpress';
import NotFound from './NotFound';
import Pager from './Pager';
import type { PostType } from '../types';

const PostList = (): React.JSX.Element => {
  const [posts, setPosts] = useState<PostType[] | null>(null);
  const [isError, setIsError] = useState(false);
  const pageNum = Simpress.React.getPage();

  useEffect(() => {
    let isMounted = true;

    if (isMounted) {
      Simpress.getPostsByPage(pageNum).then((posts) => {
        setPosts(posts);
        setIsError(false);
      }).catch(() => setIsError(true));
    }

    return (): void => {
      isMounted = false;
    };
  }, [pageNum]);

  if (isError) {
    return (
      <NotFound />
    );
  }

  return (
    <>
      {posts?.map((post) => {
        return (
          <div key={post.id}>
            <h4 key={post.id}><Link to={post.permalink}>{post.title}</Link></h4>
          </div>
        );
      })}
      <div style={{ width: '500px', wordWrap: 'break-word' }}>
        <Pager />
      </div>
    </>
  );
};

export default PostList;
