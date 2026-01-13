import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

const PostListSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      <div className="row justify-content-center">
        <div className="col col-lg-8">
          {Array.from({ length: 10 }).map((_, index) => {
            const key = `skeleton-${index}`;

            return (
              <div key={key} className="card m-4 mb-5" role="listitem" aria-label="post-skeleton">
                <Skeleton height={180} width="100%" />
                <div className="card-body">
                  <h3 className="card-title">
                    <Skeleton height={24} width="70%" />
                  </h3>
                  <Skeleton count={2} height={16} style={{ marginTop: '8px' }} />
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </SkeletonTheme>
  );
};

export default PostListSkeleton;
