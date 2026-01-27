import { useCallback } from 'react';
import { Link } from 'react-router-dom';
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
    <ul id="recent_posts">
      {data.map((post) => (
        <li key={post.id} className="recent-post">
          <Link to={post.permalink}>{post.title}</Link>
        </li>
      ))}
    </ul>
  );
};

export default RecentPosts;
