import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import PostList from '../../src/components/PostList';
import { testPostData } from '../fixtures/testPostData';
import type { PostType } from '../../src/types';

describe('PostList', () => {
  test('<PostList> test', () => {
    const posts: PostType[] = [testPostData];
    render(
      <MemoryRouter>
        <PostList posts={posts} />
      </MemoryRouter>
    );

    const elms = screen.getAllByRole('listitem', { name: 'post' });
    expect(elms).toHaveLength(1);
  });
});
