import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

const PostPageSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      <div className="container mt-5 flex-grow-1">
        <div className="row g-0">
          <div className="col col-lg-12">
            <Skeleton height={30} width={200} style={{ marginBottom: '10px' }} />
          </div>
          <div className="col col-lg-8">
            <div id="content">
              <div className="post" role="main">
                <Skeleton height={40} width="70%" style={{ marginBottom: '10px' }} />
                <Skeleton count={5} style={{ marginBottom: '10px' }} />
                <Skeleton height={20} width="30%" style={{ marginBottom: '10px' }} />
                <Skeleton count={3} style={{ marginBottom: '10px' }} />
                <Skeleton height={200} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </SkeletonTheme>
  );
};

export default PostPageSkeleton;
