import { act, render, screen } from '@testing-library/react';
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
    jest.clearAllTimers();
  });

  test('<ArchivesPage> test', async () => {
    SimpressMock.getPostsByArchive.mockResolvedValue([testPostData]);
    SimpressMock.getRecentPosts.mockResolvedValue([testPostData]);
    renderArchives();
    act(() => {
      jest.runAllTimers();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('useYearOfMonthから返ってくる値にnullが入ってる場合', async () => {
    render(
      <MemoryRouter>
        <ArchivesPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostsByArchiveがエラーを吐いた場合', async () => {
    SimpressMock.getPostsByArchive.mockRejectedValue(new Error('ERROR'));
    renderArchives();
    act(() => {
      jest.runAllTimers();
    });

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });
});
