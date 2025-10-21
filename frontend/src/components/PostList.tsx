import { Link } from 'react-router-dom';
import type { PostType } from '../types';

const PostList = ({ posts }: { posts: PostType[] }): React.JSX.Element => {
  return (
    <div className="row justify-content-center">
      <div className="col col-lg-8">
        {posts.map((post) => {
          return (
            <div className="card m-4 mb-5" key={post.id} role="list" aria-label="post">
              <img className="card-img-top" src={post.cover} />
              <div className="card-body">
                <h3 className="card-title">
                  <Link to={post.permalink}>{post.title}</Link>
                </h3>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default PostList;
