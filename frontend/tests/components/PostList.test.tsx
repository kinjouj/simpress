import { render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import PostList from '../../src/components/PostList';
import type { PostType } from '../../src/types';
import '@testing-library/jest-dom';

describe('PostList', () => {
  test('<PostList> test', async () => {
    const posts: PostType[] = [
      {
        id: '1',
        title: 'test1',
        date: Date.now().toString(),
        permalink: '/test.html',
        cover: '/images/no_image.png',
        categories: [],
        content: 'test1',
      },
    ];
    render(
      <MemoryRouter>
        <PostList posts={posts} />
      </MemoryRouter>
    );

    await waitFor(() => {
      const elms = screen.getAllByRole('listitem', { name: 'post' });
      expect(elms).toHaveLength(1);
    });
  });
});
