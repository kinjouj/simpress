import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import ArchivesPostListPage from '../../src/pages/ArchivesPostListPage';
import type Simpress from '../../src/simpress';
import type { PostType } from '../../src/types';
import type { RenderResult } from '@testing-library/react';
import '@testing-library/jest-dom';

const mockGetPostsByArchive = jest.fn<Promise<PostType[]>, [ number, number]>();
jest.mock('../../src/simpress', (): Simpress => ({
  getPostsByArchive: (year: number, month: number) => mockGetPostsByArchive(year, month),
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

const renderArchivesPostListPage = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/archives/1234/01']}>
      <Routes>
        <Route path="/archives/:year/:month" element={<ArchivesPostListPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('ArchivesPostListPage', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    jest.clearAllMocks();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('<ArchivesPostListPage> test', async () => {
    mockGetPostsByArchive.mockResolvedValue([testData]);
    renderArchivesPostListPage();

    await waitFor(() => expect(mockGetPostsByArchive).toHaveBeenCalled());
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('list');
    expect(posts).toHaveLength(1);
  });

  test('useYearOfMonthから返ってくる値にnullが入ってる場合', () => {
    render(
      <MemoryRouter>
        <ArchivesPostListPage />
      </MemoryRouter>
    );

    expect(screen.queryByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostsByArchiveがエラーを吐いた場合', async () => {
    mockGetPostsByArchive.mockRejectedValue(new Error('ERROR'));
    renderArchivesPostListPage();

    await waitFor(() => {
      expect(screen.queryByText('Not Found')).toBeInTheDocument();
    });
  });
});
