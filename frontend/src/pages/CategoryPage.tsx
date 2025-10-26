import { useState, useEffect } from 'react';
import Simpress from '../api/Simpress';
import MyClipLoader from '../components/ui/MyClipLoader';
import NotFound from '../components/ui/NotFound';
import PostList from '../components/PostList';
import { useCategory } from '../hooks';
import type { PostType } from '../types';

const CategoryPage = (): React.JSX.Element => {
  const category = useCategory();
  const [categoryPosts, setCategoryPosts] = useState<PostType[] | null>(null);
  const [isError, setIsError] = useState(false);

  useEffect(() => {
    ((): void => {
      setCategoryPosts(null);
      setIsError(false);
    })();

    const setErrorState = (): void => {
      setCategoryPosts(null);
      setIsError(true);
    };

    if (category === null) {
      setErrorState();
      return;
    }

    void (async (): Promise<void> => {
      try {
        const categoryPosts = await Simpress.getPostsByCategory(category);
        setTimeout(() => {
          setCategoryPosts(categoryPosts);
          setIsError(false);
        }, 1000);
      } catch {
        setErrorState();
      }
    })();
  }, [category]);

  if (isError) {
    return <NotFound />;
  }

  if (categoryPosts === null) {
    return <MyClipLoader />;
  }

  return <PostList posts={categoryPosts} />;
};

export default CategoryPage;
