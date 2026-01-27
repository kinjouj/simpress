import { act, render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import PostListPage from '../../src/pages/PostListPage';
import Simpress from '../../src/api/Simpress';
import { testPostData } from '../fixtures/testPostData';
import type { RenderResult } from '@testing-library/react';

jest.mock('../../src/api/Simpress');
const SimpressMock = jest.mocked(Simpress);

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
    jest.clearAllTimers();
  });

  test('<PostListPage> test', async () => {
    SimpressMock.getPostsByPage.mockResolvedValue([testPostData]);
    SimpressMock.getRecentPosts.mockResolvedValue([testPostData]);
    renderPostListPage();

    await act(async () => {
      jest.runAllTimers();
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('Simpress.getPostsByPageがエラーを吐いた場合', async () => {
    SimpressMock.getPostsByPage.mockRejectedValue(new Error('ERR'));
    renderPostListPage();
    await act(async () => {
      jest.runAllTimers();
      await Promise.resolve();
    });

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });
});
