import { Col, Row } from 'react-bootstrap';
import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

const PostPageSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      <Row>
        <Col lg={7}>
          <div id="content" className="m-4 mb-5">
            <div role="main" className="post">
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
        </Col>
        <Col lg={4} className="mt-4">
          <aside>
            <Skeleton height="100%" />
          </aside>
        </Col>
      </Row>
    </SkeletonTheme>
  );
};

export default PostPageSkeleton;
