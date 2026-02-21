import { Link } from 'react-router-dom';
import { Card, Col, Row, Stack } from 'react-bootstrap';
import { CreatedAt } from './ui';
import RecentPosts from './RecentPosts';
import type { PostType } from '../types';

const PostList = ({ posts }: { posts: PostType[] }): React.JSX.Element => {
  return (
    <Row className="g-0">
      <Col lg={7}>
        {posts.map((post) => {
          return (
            <Card key={post.id} className="position-relative rounded-4 mb-5 overflow-hidden" role="listitem" aria-label="post">
              <Card.Header className="py-3">
                <CreatedAt dateString={post.date} />
              </Card.Header>
              <Card.Img src={post.cover} variant="top" className="object-fit-cover rounded-0" />
              <Card.Body className="card-body">
                <Card.Title as="h3" className="mb-4">
                  <Link to={post.permalink} state={{ source: post.source }} className="stretched-link fs-2 fw-bold">{post.title}</Link>
                </Card.Title>
                <Card.Text>
                  {post.description}
                </Card.Text>
              </Card.Body>
              <Card.Footer className="position-relative mt-3">
                <Stack direction="horizontal" gap={3} className="justify-content-end p-2 pe-0">
                  {post.categories.map((category) => {
                    return (
                      <div key={category.key}>
                        <Link to={`/archives/category/${category.key}`} className="post-category">{category.name}</Link>
                      </div>
                    );
                  })}
                </Stack>
              </Card.Footer>
            </Card>
          );
        })}
      </Col>
      <Col xs={12} lg={4} className="ms-auto ps-5">
        <aside className="sidebar">
          <div id="recent_posts">
            <h4>Recent Posts</h4>
            <RecentPosts />
          </div>
        </aside>
      </Col>
    </Row>
  );
};

export default PostList;
