import { act, render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import PostPage from '../../src/pages/PostPage';
import Simpress from '../../src/api/Simpress';
import { testPostData } from '../fixtures/testPostData';
import type { RenderResult } from '@testing-library/react';

jest.mock('../../src/api/Simpress');
const SimpressMock = jest.mocked(Simpress);

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
    jest.clearAllTimers();
  });

  test('<PostPage> test', async () => {
    SimpressMock.getPost.mockResolvedValue(testPostData);
    SimpressMock.getRecentPosts.mockResolvedValue([testPostData]);
    renderPostPage();
    act(() => {
      jest.runAllTimers();
    });

    const post = await screen.findByRole('main');
    expect(post).toBeInTheDocument();
  });

  test('usePermalinkがnullを返した場合', async () => {
    render(
      <MemoryRouter>
        <PostPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostがエラーを出した場合', async () => {
    SimpressMock.getPost.mockRejectedValue(new Error('ERROR'));
    renderPostPage();
    act(() => {
      jest.runAllTimers();
    });

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });
});
