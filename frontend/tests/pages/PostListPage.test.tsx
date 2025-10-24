import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import PostListPage from '../../src/pages/PostListPage';
import Simpress from '../../src/api/Simpress';
import type { RenderResult } from '@testing-library/react';
import type { PostType } from '../../src/types';
import '@testing-library/jest-dom';

jest.mock('../../src/api/Simpress');
const SimpressMock = Simpress as jest.Mocked<typeof Simpress>;

const testData: PostType = {
  id: '1',
  title: 'test1',
  date: Date.now().toString(),
  permalink: '/test.html',
  cover: '/images/no_image.png',
  categories: [{ key: 'test', count: 1, name: 'Test' }],
  content: 'test1',
};

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
    SimpressMock.getPostsByPage.mockResolvedValue([testData]);
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
