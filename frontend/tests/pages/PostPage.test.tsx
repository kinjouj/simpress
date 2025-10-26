import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import PostPage from '../../src/pages/PostPage';
import Simpress from '../../src/api/Simpress';
import { testPostData } from '../fixtures/testPostData';
import type { RenderResult } from '@testing-library/react';

jest.mock('../../src/api/Simpress');
const SimpressMock = Simpress as jest.Mocked<typeof Simpress>;

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
    SimpressMock.getPost.mockResolvedValue(testPostData);
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
