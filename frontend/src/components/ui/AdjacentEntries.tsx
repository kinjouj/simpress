import { Link } from 'react-router';
import type { EntryLinkType } from '../../types';

const AdjacentEntries = ({ next, prev }: { next: EntryLinkType | null, prev: EntryLinkType | null }): React.JSX.Element => {
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

export default AdjacentEntries;
