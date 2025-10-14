import { useState, useEffect } from 'react';
import Simpress from '../simpress';
import MyClipLoader from '../components/MyClipLoader';
import NotFound from '../components/NotFound';
import PostList from '../components/PostList';
import { useCategory } from '../hooks';
import type { PostType } from '../types';

const CategoryPostListPage = (): React.JSX.Element => {
  const category = useCategory();
  const [categoryPosts, setCategoryPosts] = useState<PostType[] | null>(null);
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    ((): void => {
      setCategoryPosts(null);
      setIsLoading(true);
      setIsError(false);
    })();

    const setErrorState = (): void => {
      setIsLoading(false);
      setIsError(true);
    };

    if (category === null) {
      setErrorState();
      return;
    }

    Simpress.getPostsByCategory(category).then((categoryPosts) => {
      setTimeout(() => {
        setCategoryPosts(categoryPosts);
        setIsLoading(false);
        setIsError(false);
      }, 1000);
    }).catch(() => {
      setErrorState();
    });
  }, [category]);

  if (isError) return <NotFound />;
  if (isLoading || categoryPosts === null) return <MyClipLoader loading={isLoading} />;

  return <PostList posts={categoryPosts} />;
};

export default CategoryPostListPage;
