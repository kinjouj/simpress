import { useCallback } from 'react';
import { Link } from 'react-router-dom';
import { Stack } from 'react-bootstrap';
import Simpress from '../api/Simpress';
import { useFetchData } from '../hooks';
import { NotFound } from './ui';

const RecentPosts = (): React.JSX.Element => {
  const fetcher = useCallback(() => {
    return Simpress.getRecentPosts();
  }, []);

  const { data, isError } = useFetchData(fetcher);

  if (isError) {
    return (<div>Error</div>);
  }

  if (data === null) {
    return <NotFound />;
  }

  return (
    <Stack>
      {data.map((post) => (
        <div key={post.id}>
          <Link to={post.permalink} role="listitem">{post.title}</Link>
        </div>
      ))}
    </Stack>
  );
};

export default RecentPosts;
