import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

/*
  <div className="container">
    <div className="row">
      <div className="col col-lg-8">
        <div id="content" className="m-4 mb-5"></div>
          <Skeleton height={30} width={200} style={{ marginBottom: '10px' }} />
        </div>
        <div className="post" role="main">
          <Skeleton height={40} width="70%" style={{ marginBottom: '10px' }} />
          <Skeleton count={5} style={{ marginBottom: '10px' }} />
          <Skeleton height={20} width="30%" style={{ marginBottom: '10px' }} />
          <Skeleton count={3} style={{ marginBottom: '10px' }} />
          <Skeleton height={200} />
        </div>
      </div>
    </div>
*/

const PostPageSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      <div className="container">
        <div className="row">
          <div className="col col-lg-8">
            <div id="content" className="m-4 mb-5">
              <div className="post" role="main">
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
            </div>
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

export default PostPageSkeleton;
