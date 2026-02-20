import { Link } from 'react-router-dom';
import type { SimilarityType } from '../types';

const RelatedPosts = ({ similarities }: { similarities: SimilarityType[] }): React.JSX.Element => {
  return (
    <div className="post-similarity">
      <fieldset className="rounded-1 p-2 pb-0">
        <legend>関連記事</legend>
        <ul>
          {similarities.map((similarity) => (
            <li key={similarity.id} className="my-2">
              <Link className="d-block p-2" to={similarity.permalink}>{similarity.title}</Link>
            </li>
          ))}
        </ul>
      </fieldset>
    </div>
  );
};

export default RelatedPosts;
