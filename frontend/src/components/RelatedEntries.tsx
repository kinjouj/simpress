import { Link } from 'react-router';
import { Stack } from 'react-bootstrap';
import type { EntryLinkType } from '../types';

const RelatedEntries = ({ similarities }: { similarities: EntryLinkType[] }): React.JSX.Element => {
  return (
    <div className="entry-similarity">
      <fieldset className="rounded-1 p-2 pb-0">
        <legend>関連記事</legend>
        <Stack>
          {similarities.map(({ id, title, permalink }) => (
            <div key={id} className="my-2">
              <Link to={permalink} className="d-block p-2" role="listitem">{title}</Link>
            </div>
          ))}
        </Stack>
      </fieldset>
    </div>
  );
};

export default RelatedEntries;
