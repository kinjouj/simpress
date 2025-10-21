import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import PostListPage from '../../src/pages/PostListPage';
import type Simpress from '../../src/simpress';
import type { PostType } from '../../src/types';
import type { RenderResult } from '@testing-library/react';
import '@testing-library/jest-dom';

const mockGetPostsByPage = jest.fn<Promise<PostType[]>, [ number ]>();
jest.mock('../../src/simpress', (): Simpress => ({
  getPostsByPage: (pageNum: number) => mockGetPostsByPage(pageNum),
}));

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
    jest.clearAllMocks();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('<PostListPage> test', async () => {
    mockGetPostsByPage.mockResolvedValue([testData]);
    renderPostListPage();

    await waitFor(() => expect(mockGetPostsByPage).toHaveBeenCalled());
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('list');
    expect(posts).toHaveLength(1);
  });

  test('Simpress.getPostsByPageがエラーを吐いた場合', async () => {
    mockGetPostsByPage.mockRejectedValue(new Error('ERR'));
    renderPostListPage();

    await waitFor(() => {
      expect(screen.queryByText('Not Found')).toBeInTheDocument();
    });
  });
});
