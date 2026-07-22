import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import { RelatedPosts } from '../../src/components';
import { testPostData } from '../fixtures/testPostData';

describe('RelatedPosts', () => {
  test('<RelatedPosts> test', async () => {
    render(
      <MemoryRouter>
        <RelatedPosts similarities={[{ id: testPostData.id, title: testPostData.title, permalink: testPostData.permalink }]} />
      </MemoryRouter>
    );

    expect(await screen.findAllByRole('listitem')).toHaveLength(1);
  });
});
