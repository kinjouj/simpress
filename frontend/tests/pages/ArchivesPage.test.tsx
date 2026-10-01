import { render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router';
import ArchivesPage from '../../src/pages/ArchivesPage';
import Simpress from '../../src/api/Simpress';
import { testEntryData } from '../fixtures/testEntryData';
import type { RenderResult } from '@testing-library/react';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

const renderArchives = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/archives/1234/01/1']}>
      <Routes>
        <Route path="/archives/:year/:month/:page" element={<ArchivesPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('ArchivesPage', () => {
  beforeEach(() => {
    vi.spyOn(window, 'scrollTo').mockImplementation(() => {});
  });

  test('<ArchivesPage> test', async () => {
    SimpressMock.getEntriesByArchive.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    renderArchives();

    const entries = await screen.findAllByRole('listitem', { name: 'entry' }, { timeout: 10000 });
    expect(entries).toHaveLength(1);
  });

  test('useYearOfMonthから返ってくる値にnullが入ってる場合', async () => {
    render(
      <MemoryRouter>
        <ArchivesPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getEntriesByArchiveがエラーを吐いた場合', async () => {
    SimpressMock.getEntriesByArchive.mockRejectedValue(new Error('ERROR'));
    renderArchives();

    expect(await screen.findByText('Not Found', {}, { timeout: 10000 })).toBeInTheDocument();
  });
});
