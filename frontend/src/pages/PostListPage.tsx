import { useState, useEffect } from 'react';
import Simpress from '../simpress';
import MyClipLoader from '../components/MyClipLoader';
import NotFound from '../components/NotFound';
import PostList from '../components/PostList';
import Pager from '../components/Pager';
import { usePage } from '../hooks';
import type { PostType } from '../types';

const PostListPage = (): React.JSX.Element => {
  const [posts, setPosts] = useState<PostType[] | null>(null);
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const pageNum = usePage();

  useEffect(() => {
    ((): void => {
      setPosts(null);
      setIsLoading(true);
      setIsError(false);
    })();

    Simpress.getPostsByPage(pageNum).then((posts) => {
      setTimeout(() => {
        setPosts(posts);
        setIsLoading(false);
        setIsError(false);
      }, 1000);
    }).catch(() => {
      setIsLoading(false);
      setIsError(true);
    });
  }, [pageNum]);

  if (isError) return <NotFound />;
  if (isLoading || posts === null) return <MyClipLoader loading={isLoading} />;

  return (
    <div className="container">
      <PostList posts={posts} />
      <Pager />
    </div>
  );
};

export default PostListPage;
