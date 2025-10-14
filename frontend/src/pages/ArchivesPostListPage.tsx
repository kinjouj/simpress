import { useEffect, useState } from 'react';
import Simpress from '../simpress';
import MyClipLoader from '../components/MyClipLoader';
import NotFound from '../components/NotFound';
import PostList from '../components/PostList';
import { useYearOfMonth } from '../hooks';
import type { PostType } from '../types';

const ArchivesPostListPage = (): React.JSX.Element => {
  const { year, month } = useYearOfMonth();
  const [posts, setPosts] = useState<PostType[] | null>(null);
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    ((): void => {
      setPosts(null);
      setIsLoading(true);
      setIsError(false);
    })();

    const setErrorState = (): void => {
      setIsLoading(false);
      setIsError(true);
    };

    if (year === null || month === null) {
      setErrorState();
      return;
    }

    Simpress.getPostsByArchive(year, month).then((posts) => {
      setTimeout(() => {
        setPosts(posts);
        setIsLoading(false);
        setIsError(false);
      }, 1000);
    }).catch(() => {
      setErrorState();
    });
  }, [year, month]);

  if (isError) return <NotFound />;
  if (isLoading || posts === null) return <MyClipLoader loading={isLoading} />;

  return <PostList posts={posts} />;
};

export default ArchivesPostListPage;
