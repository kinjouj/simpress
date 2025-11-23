import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import PostListPage from '../../src/pages/PostListPage';
import Simpress from '../../src/api/simpress';
import { testPostData } from '../fixtures/testPostData';
import type { RenderResult } from '@testing-library/react';

jest.mock('../../src/api/simpress');
const SimpressMock = Simpress as jest.Mocked<typeof Simpress>;

const renderPostListPage = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/page/1']}>
      <Routes>
        <Route path="/page/:page" element={<PostListPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('PostListPage', () => {
  beforeEach(() => {
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('<PostListPage> test', async () => {
    SimpressMock.getPostsByPage.mockResolvedValue([testPostData]);
    renderPostListPage();

    await waitFor(() => expect(SimpressMock.getPostsByPage).toHaveBeenCalled());
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('Simpress.getPostsByPageがエラーを吐いた場合', async () => {
    SimpressMock.getPostsByPage.mockRejectedValue(new Error('ERR'));
    renderPostListPage();

    await waitFor(() => {
      expect(screen.queryByText('Not Found')).toBeInTheDocument();
    });
  });
});
