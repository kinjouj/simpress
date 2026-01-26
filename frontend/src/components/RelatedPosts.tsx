import { Link } from 'react-router-dom';
import type { SimilarityType } from '../types';

const RelatedPosts = ({ similarities }: { similarities: SimilarityType[] }): React.JSX.Element => {
  return (
    <div className="post-similarity">
      <fieldset className="p-2">
        <legend>関連記事</legend>
        <ul>
          {similarities.map((similarity) => (
            <li key={similarity.id}>
              <Link className="p-3 related-link" to={similarity.permalink}>{similarity.title}</Link>
            </li>
          ))}
        </ul>
      </fieldset>
    </div>
  );
};

export default RelatedPosts;
