import { Link } from 'react-router-dom';
import type { AdjacentType } from '../../types';

const AdjacentPosts = ({ adjacent }: { adjacent: AdjacentType }): React.JSX.Element => {
  return (
    <div className="paginator d-flex my-5">
      {!!adjacent.next && (
        <Link to={adjacent.next.permalink} rel="prev">&lt;&nbsp;{adjacent.next.title}</Link>
      )}
      {!!adjacent.prev && (
        <Link to={adjacent.prev.permalink} rel="next">{adjacent.prev.title}&nbsp;&gt;</Link>
      )}
    </div>
  );
};

export default AdjacentPosts;
