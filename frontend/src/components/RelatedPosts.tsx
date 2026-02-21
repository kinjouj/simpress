import { Link } from 'react-router-dom';
import { Stack } from 'react-bootstrap';
import type { SimilarityType } from '../types';

const RelatedPosts = ({ similarities }: { similarities: SimilarityType[] }): React.JSX.Element => {
  return (
    <div className="post-similarity">
      <fieldset className="rounded-1 p-2 pb-0">
        <legend>関連記事</legend>
        <Stack>
          {similarities.map((similarity) => (
            <div key={similarity.id} className="my-2">
              <Link to={similarity.permalink} className="d-block p-2" role="listitem">{similarity.title}</Link>
            </div>
          ))}
        </Stack>
      </fieldset>
    </div>
  );
};

export default RelatedPosts;
