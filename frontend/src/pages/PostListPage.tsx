import { useCallback } from 'react';
import Simpress from '../api/Simpress';
import { MyClipLoader, NotFound, Pager, PostList } from '../components';
import { useFetchData, usePage } from '../hooks';
import type { PostType } from '../types';

const PostListPage = (): React.JSX.Element => {
  const pageNum = usePage();

  const fetcher = useCallback(() => {
    return Simpress.getPostsByPage(pageNum);
  }, [pageNum]);

  const { data: posts, isError } = useFetchData<PostType[]>(fetcher);

  if (isError) {
    return <NotFound />;
  }

  if (posts === null) {
    return <MyClipLoader />;
  }

  return (
    <div className="container mt-5 flex-grow-1">
      <PostList posts={posts} />
      <Pager />
    </div>
  );
};

export default PostListPage;
