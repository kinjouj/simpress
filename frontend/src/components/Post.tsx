import { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { Link } from 'react-router-dom';
import Simpress from '../simpress';
import NotFound from './NotFound';
import type { PostType, CategoryType } from '../types';

const usePermalink = (): string | undefined => {
  const params = useParams();
  return params['*'];
};

const Post = (): React.JSX.Element => {
  const permalink = usePermalink();
  const [data, setData] = useState<PostType | null>(null);
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (permalink == null) return;

    Simpress.getPost(permalink).then((data) => {
      setData(data);
      setIsError(false);
    }).catch(() => setIsError(true)).finally(() => setIsLoading(false));
  }, [permalink]);

  if (isLoading) {
    return (
      <div>Now Loading...</div>
    );
  }

  if (permalink == null || isError || data == null) {
    return (
      <NotFound />
    );
  }

  return (
    <div>
      <div>
        <h4>{data.title}</h4>
      </div>
      <div>
        {data.categories.map((category: CategoryType) => {
          return (
            <Link key={category.key} to={`/category/${category.key}`} style={{ margin: '3px' }}>{category.name}</Link>
          );
        })}
      </div>
      <div>
        <pre dangerouslySetInnerHTML={{ __html: data.content }}></pre>
      </div>
      <div style={{ marginTop: '10px' }}>
        <pre>{JSON.stringify(data, null, 2)}</pre>
      </div>
    </div>
  );
};

export default Post;
