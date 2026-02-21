import { Row, Col, Card } from 'react-bootstrap';
import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

const PostListSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      <Row>
        <Col lg={7}>
          {Array.from({ length: 10 }).map((_, index) => {
            const key = `skeleton-${index}`;

            return (
              <Card key={key} className="m-4 mb-5" role="listitem" aria-label="post-skeleton">
                <Skeleton height={200} />
              </Card>
            );
          })}
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

export default PostListSkeleton;
