import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

const PostPageSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      <div role="main" className="post mx-4 mb-5">
        <div className="post-date">
          <Skeleton />
        </div>
        <div className="post-title">
          <Skeleton />
        </div>
        <p className="meta">
          <Skeleton />
        </p>
        <div className="post-content">
          <Skeleton height={300} />
        </div>
      </div>
    </SkeletonTheme>
  );
};

export default PostPageSkeleton;
