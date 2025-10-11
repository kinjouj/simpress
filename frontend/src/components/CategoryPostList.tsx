import { useState, useEffect } from 'react';
import { Link, useParams } from 'react-router-dom';
import Simpress from '../simpress';
import NotFound from './NotFound';
import type { PostType } from '../types';

const useCategory = (): string | undefined => {
  const { category } = useParams();
  return category;
};

const CategoryPostList = (): React.JSX.Element => {
  const category = useCategory();
  const [categoryPosts, setCategoryPosts] = useState<PostType[] | null>(null);
  const [isError, setIsError] = useState(false);

  useEffect(() => {
    if (category == null) return;

    Simpress.getPostsByCategory(category).then((categoryPosts) => {
      setCategoryPosts(categoryPosts);
      setIsError(false);
    }).catch(() => setIsError(true));
  }, [category]);

  if (category == null || isError) return <NotFound />;

  return (
    <>
      {categoryPosts?.map((categoryPost) => {
        return (
          <div key={categoryPost.id}>
            <h4><Link to={categoryPost.permalink}>{categoryPost.title}</Link></h4>
          </div>
        );
      })}
    </>
  );
};

export default CategoryPostList;
