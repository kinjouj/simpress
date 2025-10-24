import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import PostPage from '../../src/pages/PostPage';
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
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('<PostPage> test', async () => {
    SimpressMock.getPost.mockResolvedValue(testData);
    renderPostPage();

    await waitFor(() => expect(SimpressMock.getPost).toHaveBeenCalled());
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
    SimpressMock.getPost.mockRejectedValue(new Error('ERROR'));
    renderPostPage();

    await waitFor(() => {
      expect(screen.queryByText('Not Found')).toBeInTheDocument();
    });
  });
});
