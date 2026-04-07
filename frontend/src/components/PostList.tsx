import { Link } from 'react-router-dom';
import { Card, Stack } from 'react-bootstrap';
import { CreatedAt } from './ui';
import type { PostType } from '../types';

const PostList = ({ posts }: { posts: PostType[] }): React.JSX.Element => {
  return (
    <>
      {posts.map((post) => {
        return (
          <Card key={post.id} className="position-relative rounded-4 mb-5 overflow-hidden" role="listitem" aria-label="post">
            <Card.Header className="py-3">
              <CreatedAt dateString={post.date} />
            </Card.Header>
            <Card.Img src={post.cover} variant="top" className="object-fit-cover rounded-0" />
            <Card.Body>
              <Card.Title as="h3" className="mb-4">
                <Link to={post.permalink} className="stretched-link fs-2 fw-bold">{post.title}</Link>
              </Card.Title>
              <Card.Text>
                {post.description}
              </Card.Text>
            </Card.Body>
            <Card.Footer className="position-relative mt-3">
              <Stack direction="horizontal" gap={3} className="justify-content-end p-2 pe-0">
                {Object.entries(post.taxonomies).map(([taxonomy, terms]) => {
                  return terms.map((term) => (
                    <div key={term.key}>
                      <Link to={`/archives/${taxonomy}/${term.key}`} className="post-category">{term.name}</Link>
                    </div>
                  ));
                })}
              </Stack>
            </Card.Footer>
          </Card>
        );
      })}
    </>
  );
};

export default PostList;
