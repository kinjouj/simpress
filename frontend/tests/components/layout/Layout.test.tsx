import { act, render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import Simpress from '../../../src/api/Simpress';
import Layout from '../../../src/components/layout/Layout';
import { testPostData } from '../../fixtures/testPostData';

jest.mock('../../../src/api/Simpress');
const SimpressMock = jest.mocked(Simpress);

describe('Layout', () => {
  beforeEach(() => {
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.clearAllTimers();
    jest.useRealTimers();
  });

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

    await act(async () => {
      await jest.runAllTimersAsync();
    });

    const posts = await screen.findAllByRole('listitem');
    expect(posts).toHaveLength(1);
  });
});
