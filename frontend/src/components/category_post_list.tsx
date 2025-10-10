import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Simpress from '../simpress';
import NotFound from './not_found';
import type { PostType } from '../types';

const CategoryPostList = (): React.JSX.Element => {
  const category = Simpress.React.getCategory();

  if (category == null) return <NotFound />;

  const [categoryPosts, setCategoryPosts] = useState<PostType[] | null>(null);
  const [isError, setIsError] = useState(false);

  useEffect(() => {
    Simpress.getPostsByCategory(category).then((categoryPosts) => {
      setCategoryPosts(categoryPosts);
      setIsError(false);
    }).catch(() => setIsError(true));
  }, [category]);

  if (isError) return <NotFound />;

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
