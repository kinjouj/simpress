import { render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router';
import Simpress from '../../../src/api/Simpress';
import Layout from '../../../src/components/layout/Layout';
import { testPostData } from '../../fixtures/testPostData';

vi.mock('../../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

describe('Layout', () => {
  test('renders header, footer, the outlet content, and the recent posts sidebar', async () => {
    SimpressMock.getRecentPosts.mockResolvedValue([testPostData]);

    render(
      <MemoryRouter initialEntries={['/']}>
        <Routes>
          <Route element={<Layout />}>
            <Route path="/" element={<div>page content</div>} />
          </Route>
        </Routes>
      </MemoryRouter>
    );

    expect(screen.getByText('page content')).toBeInTheDocument();
    expect(screen.getByText('Recent Posts')).toBeInTheDocument();

    const posts = await screen.findAllByRole('listitem', {}, { timeout: 10000 });
    expect(posts).toHaveLength(1);
  });
});
