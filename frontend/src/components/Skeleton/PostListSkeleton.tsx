import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

const PostListSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      <div className="container">
        <div className="row">
          <div className="col col-lg-8">
            {Array.from({ length: 10 }).map((_, index) => {
              const key = `skeleton-${index}`;

              return (
                <div key={key} className="card m-4 mb-5" role="listitem" aria-label="post-skeleton">
                  <Skeleton height={200} />
                </div>
              );
            })}
          </div>
          <div className="col col-lg-4 mt-4">
            <aside>
              <Skeleton height="100%" />
            </aside>
          </div>
        </div>
      </div>
    </SkeletonTheme>
  );
};

export default PostListSkeleton;
