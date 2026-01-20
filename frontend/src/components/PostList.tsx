import { Link } from 'react-router-dom';
import { CreatedAt } from './ui';
import RecentPosts from './RecentPosts';
import type { PostType } from '../types';

const PostList = ({ posts }: { posts: PostType[] }): React.JSX.Element => {
  return (
    <div className="container">
      <div className="row">
        <div className="col col-lg-8">
          {posts.map((post) => {
            return (
              <div key={post.id} className="card m-4 mb-5" role="listitem" aria-label="post">
                <div className="card-header">
                  <CreatedAt dateString={post.date} />
                </div>
                <img className="card-img-top" src={post.cover} style={{ borderRadius: '0' }} />
                <div className="card-body">
                  <h3 className="card-title mb-3">
                    <Link to={post.permalink}>{post.title}</Link>
                  </h3>
                  {post.description}
                </div>
                <div className="card-footer p-3">
                  <ul className="d-flex justify-content-end gap-3 m-0">
                    {post.categories.map((category) => {
                      return (
                        <li key={category.key}>
                          <Link to={`/archives/category/${category.key}`}>{category.name}</Link>
                        </li>
                      );
                    })}
                  </ul>
                </div>
              </div>
            );
          })}
        </div>
        <div className="col col-lg-4 mt-4">
          <aside>
            <div id="recent_posts">
              <h4>Recent Posts</h4>
              <RecentPosts />
            </div>
          </aside>
        </div>
      </div>
    </div>
  );
};

export default PostList;
