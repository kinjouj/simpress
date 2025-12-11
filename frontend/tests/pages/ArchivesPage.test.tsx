import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import ArchivesPage from '../../src/pages/ArchivesPage';
import Simpress from '../../src/api/Simpress';
import { testPostData } from '../fixtures/testPostData';
import type { RenderResult } from '@testing-library/react';

jest.mock('../../src/api/Simpress');
const SimpressMock = jest.mocked(Simpress);

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
    SimpressMock.getPostsByArchive.mockResolvedValue([testPostData]);
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
