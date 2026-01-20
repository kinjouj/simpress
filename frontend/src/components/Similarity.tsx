import { useCallback } from 'react';
import { Link } from 'react-router-dom';
import Simpress from '../api/Simpress';
import { useFetchData } from '../hooks';
import { NotFound } from './ui';
import type { SimilarityType, PostType } from '../types';

const Similarity = ({ post }: { post: PostType }): React.JSX.Element => {
  const fetcher = useCallback(() => {
    return Simpress.getSimilarity(post.id);
  }, [post]);

  const { data, isError } = useFetchData<SimilarityType>(fetcher);

  if (isError) {
    return (<div>Error</div>);
  }

  if (data === null) {
    return <NotFound />;
  }

  return (
    <div className="post-similarity">
      <fieldset className="p-2">
        <legend>関連記事</legend>
        <ul>
          {data.similarity.map((similarity) => (
            <li key={similarity.id}>
              <Link className="p-3 related-link" to={similarity.permalink}>{similarity.title}</Link>
            </li>
          ))}
        </ul>
      </fieldset>
    </div>
  );
};

export default Similarity;
