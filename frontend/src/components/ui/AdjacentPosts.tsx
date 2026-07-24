import { Link } from 'react-router-dom';
import type { PostLinkType } from '../../types';

const AdjacentPosts = ({ next, prev }: { next: PostLinkType | null, prev: PostLinkType | null }): React.JSX.Element => {
  return (
    <div className="paginator d-flex my-5">
      {!!next && (
        <Link to={next.permalink} rel="prev">&lt;&nbsp;{next.title}</Link>
      )}
      {!!prev && (
        <Link to={prev.permalink} rel="next">{prev.title}&nbsp;&gt;</Link>
      )}
    </div>
  );
};

export default AdjacentPosts;
