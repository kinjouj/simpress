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

  useEffect(() => {
    ((): void => {
      setPosts(null);
      setIsError(false);
    })();

    const setErrorState = (): void => {
      setPosts(null);
      setIsError(true);
    };

    if (year === null || month === null) {
      setErrorState();
      return;
    }

    void (async (): Promise<void> => {
      try {
        const posts = await Simpress.getPostsByArchive(year, month);
        setTimeout(() => {
          setPosts(posts);
          setIsError(false);
        }, 1000);
      } catch {
        setErrorState();
      }
    })();
  }, [year, month]);

  if (isError) {
    return <NotFound />;
  }

  if (posts === null) {
    return <MyClipLoader />;
  }

  return <PostList posts={posts} />;
};

export default ArchivesPostListPage;
