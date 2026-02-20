import { Link } from 'react-router-dom';
import { CreatedAt } from './ui';
import RecentPosts from './RecentPosts';
import type { PostType } from '../types';

const PostList = ({ posts }: { posts: PostType[] }): React.JSX.Element => {
  return (
    <div className="container mt-5">
      <div className="row g-0">
        <div className="col col-lg-7">
          {posts.map((post) => {
            return (
              <div key={post.id} className="card position-relative rounded-4 mb-5 overflow-hidden" role="listitem" aria-label="post">
                <div className="card-header py-3">
                  <CreatedAt dateString={post.date} />
                </div>
                <img src={post.cover} className="card-img-top object-fit-cover rounded-0" />
                <div className="card-body">
                  <h3 className="card-title mb-4">
                    <Link className="stretched-link fs-2 fw-bold" to={post.permalink} state={{ source: post.source }}>{post.title}</Link>
                  </h3>
                  <p className="card-text">
                    {post.description}
                  </p>
                </div>
                <div className="card-footer position-relative mt-3">
                  <ul className="d-flex justify-content-end gap-3 m-0 p-3 pe-0">
                    {post.categories.map((category) => {
                      return (
                        <li key={category.key}>
                          <Link className="post-category" to={`/archives/category/${category.key}`}>{category.name}</Link>
                        </li>
                      );
                    })}
                  </ul>
                </div>
              </div>
            );
          })}
        </div>
        <div className="sidebar col-12 col-lg-4 ms-auto ps-5">
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
