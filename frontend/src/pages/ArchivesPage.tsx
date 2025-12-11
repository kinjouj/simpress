import { useCallback } from 'react';
import Simpress from '../api/Simpress';
import { MyClipLoader, NotFound, PostList } from '../components';
import { useFetchData, useYearOfMonth } from '../hooks';
import type { PostType } from '../types';

const ArchivesPage = (): React.JSX.Element => {
  const { year, month } = useYearOfMonth();

  const fetcher = useCallback(() => {
    if (year === null || month === null) {
      throw new Error('year|month is null');
    }

    return Simpress.getPostsByArchive(year, month);
  }, [year, month]);

  const { data: posts, isError } = useFetchData<PostType[]>(fetcher);

  if (isError) {
    return <NotFound />;
  }

  if (posts === null) {
    return <MyClipLoader />;
  }

  return <PostList posts={posts} />;
};

export default ArchivesPage;
