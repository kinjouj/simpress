import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import PostPage from '../../src/pages/PostPage';
import type Simpress from '../../src/simpress';
import type { PostType } from '../../src/types';
import type { RenderResult } from '@testing-library/react';
import '@testing-library/jest-dom';

const mockGetPost = jest.fn<Promise<PostType>, []>();
jest.mock('../../src/simpress', (): Simpress => ({
  getPost: () => mockGetPost(),
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

const renderPostPage = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/test.json']}>
      <Routes>
        <Route path="/*" element={<PostPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('PostPage', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    jest.clearAllMocks();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('<PostPage> test', async () => {
    mockGetPost.mockResolvedValue(testData);
    renderPostPage();

    await waitFor(() => expect(mockGetPost).toHaveBeenCalled());
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const post = await screen.findByRole('main');
    expect(post).toBeInTheDocument();
  });

  test('usePermalinkがnullを返した場合', () => {
    render(
      <MemoryRouter>
        <PostPage />
      </MemoryRouter>
    );

    expect(screen.queryByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostがエラーを出した場合', async () => {
    mockGetPost.mockRejectedValue(new Error('ERROR'));
    renderPostPage();

    await waitFor(() => {
      expect(screen.queryByText('Not Found')).toBeInTheDocument();
    });
  });
});
