import { useCallback } from 'react';
import { Link } from 'react-router';
import { Stack } from 'react-bootstrap';
import Simpress from '../api/Simpress';
import { useFetchData } from '../hooks';
import { NotFound } from './ui';

const RecentEntries = (): React.JSX.Element => {
  const fetcher = useCallback(() => {
    return Simpress.getRecentEntries();
  }, []);

  const { data, isLoading, isError } = useFetchData(fetcher);

  if (isError) {
    return (<div>Error</div>);
  }

  if (isLoading) {
    return (<div>loading...</div>);
  }

  if (data === null) {
    return <NotFound />;
  }

  return (
    <Stack className="mb-3">
      {data.map((entry) => (
        <div key={entry.id}>
          <Link to={entry.permalink} role="listitem">{entry.title}</Link>
        </div>
      ))}
    </Stack>
  );
};

export default RecentEntries;
