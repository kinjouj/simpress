import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import Simpress from '../../src/api/Simpress';
import { RecentPosts } from '../../src/components';
import { testPostData } from '../fixtures/testPostData';

jest.mock('../../src/api/Simpress');
const SimpressMock = jest.mocked(Simpress);

describe('RecentPosts', () => {
  test('<RecentPosts> test', async () => {
    SimpressMock.getRecentPosts.mockResolvedValue([testPostData]);
    render(
      <MemoryRouter>
        <RecentPosts />
      </MemoryRouter>
    );

    const el = await screen.findAllByRole('listitem');
    expect(el).toHaveLength(1);
  });
});
