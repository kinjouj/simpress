import { Card } from 'react-bootstrap';
import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

const PostListSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      {Array.from({ length: 10 }).map((_, index) => {
        const key = `skeleton-${index}`;

        return (
          <Card key={key} className="mx-4 mb-5" role="listitem" aria-label="post-skeleton">
            <Skeleton height={200} />
          </Card>
        );
      })}
    </SkeletonTheme>
  );
};

export default PostListSkeleton;
