import { useState, useEffect } from 'react';
import Simpress from '../api/Simpress';
import MyClipLoader from '../components/MyClipLoader';
import NotFound from '../components/NotFound';
import PostList from '../components/PostList';
import Pager from '../components/Pager';
import { usePage } from '../hooks';
import type { PostType } from '../types';

const PostListPage = (): React.JSX.Element => {
  const [posts, setPosts] = useState<PostType[] | null>(null);
  const [isError, setIsError] = useState(false);
  const pageNum = usePage();

  useEffect(() => {
    ((): void => {
      setPosts(null);
      setIsError(false);
    })();

    void (async (): Promise<void> => {
      try {
        const posts = await Simpress.getPostsByPage(pageNum);
        setTimeout(() => {
          setPosts(posts);
          setIsError(false);
        }, 1000);
      } catch {
        setPosts([]);
        setIsError(true);
      }
    })();
  }, [pageNum]);

  if (isError) {
    return <NotFound />;
  }

  if (posts === null) {
    return <MyClipLoader />;
  }

  return (
    <div className="container">
      <PostList posts={posts} />
      <Pager />
    </div>
  );
};

export default PostListPage;
