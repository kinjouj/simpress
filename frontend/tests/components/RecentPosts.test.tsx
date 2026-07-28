import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import Simpress from '../../src/api/Simpress';
import { RecentPosts } from '../../src/components';
import { testPostData } from '../fixtures/testPostData';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

describe('RecentPosts', () => {
  test('does not show NotFound while the fetch is still in flight', () => {
    let resolveFetch: (value: (typeof testPostData)[]) => void = () => {};
    SimpressMock.getRecentPosts.mockReturnValue(
      new Promise((resolve) => {
        resolveFetch = resolve;
      })
    );

    render(
      <MemoryRouter>
        <RecentPosts />
      </MemoryRouter>
    );

    expect(screen.queryByText(/not found/i)).not.toBeInTheDocument();
    void resolveFetch;
  });

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
