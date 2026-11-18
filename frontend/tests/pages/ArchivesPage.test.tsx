import { act, render, screen } from '@testing-library/react';
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
    vi.useFakeTimers({ shouldAdvanceTime: true });
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('shows archive entries', async () => {
    SimpressMock.getEntriesByArchive.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    renderArchives();
    act(() => {
      vi.runAllTimers();
    });

    const entries = await screen.findAllByRole('listitem', { name: 'entry' });
    expect(entries).toHaveLength(1);
  });

  it('shows Not Found if null', async () => {
    render(
      <MemoryRouter>
        <ArchivesPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  it('shows Not Found on error', async () => {
    SimpressMock.getEntriesByArchive.mockRejectedValue(new Error('ERROR'));
    renderArchives();
    act(() => {
      vi.runAllTimers();
    });

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });
});
