import { Link } from 'react-router';
import { Card } from 'react-bootstrap';
import { CreatedAt, EntryCategories } from './ui';
import type { EntryType } from '../types';

const EntryList = ({ entries }: { entries: EntryType[] }): React.JSX.Element => {
  return (
    <>
      {entries.map((entry) => {
        return (
          <Card key={entry.id} className="position-relative rounded-4 mb-5 overflow-hidden" role="listitem" aria-label="entry">
            <Card.Header className="py-3">
              <CreatedAt dateString={entry.date} />
            </Card.Header>
            <Card.Img src={entry.cover} variant="top" className="object-fit-cover rounded-0" />
            <Card.Body>
              <Card.Title as="h3" className="mb-4">
                <Link to={entry.permalink} className="stretched-link fs-2 fw-bold">{entry.title}</Link>
              </Card.Title>
              <Card.Text>
                {entry.description}
              </Card.Text>
            </Card.Body>
            <Card.Footer className="position-relative mt-3">
              <EntryCategories taxonomies={entry.taxonomies} className="justify-content-end p-2 pe-0" />
            </Card.Footer>
          </Card>
        );
      })}
    </>
  );
};

export default EntryList;
