import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import ArchivesPage from '../../src/pages/ArchivesPage';
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

const renderArchives = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/archives/1234/01']}>
      <Routes>
        <Route path="/archives/:year/:month" element={<ArchivesPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('ArchivesPage', () => {
  beforeEach(() => {
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('<ArchivesPage> test', async () => {
    SimpressMock.getPostsByArchive.mockResolvedValue([testData]);
    renderArchives();

    await waitFor(() => expect(SimpressMock.getPostsByArchive).toHaveBeenCalled());
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('useYearOfMonthから返ってくる値にnullが入ってる場合', () => {
    render(
      <MemoryRouter>
        <ArchivesPage />
      </MemoryRouter>
    );

    expect(screen.queryByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostsByArchiveがエラーを吐いた場合', async () => {
    SimpressMock.getPostsByArchive.mockRejectedValue(new Error('ERROR'));
    renderArchives();

    await waitFor(() => {
      expect(screen.queryByText('Not Found')).toBeInTheDocument();
    });
  });
});
