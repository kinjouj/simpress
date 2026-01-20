import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import PostList from '../../src/components/PostList';
import { testPostData } from '../fixtures/testPostData';
import type { PostType } from '../../src/types';

describe('PostList', () => {
  test('<PostList> test', async () => {
    const posts: PostType[] = [testPostData];
    render(
      <MemoryRouter>
        <PostList posts={posts} />
      </MemoryRouter>
    );

    const elms = await screen.findAllByRole('listitem', { name: 'post' });
    expect(elms).toHaveLength(1);
  });
});
