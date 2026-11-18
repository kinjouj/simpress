import { act, render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router';
import EntryListPage from '../../src/pages/EntryListPage';
import Simpress from '../../src/api/Simpress';
import { testEntryData } from '../fixtures/testEntryData';
import type { RenderResult } from '@testing-library/react';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

const renderEntryListPage = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/page/1']}>
      <Routes>
        <Route path="/page/:page" element={<EntryListPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('EntryListPage', () => {
  beforeEach(() => {
    vi.useFakeTimers({ shouldAdvanceTime: true });
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('shows loading while fetching', () => {
    SimpressMock.getEntriesByPage.mockReturnValue(new Promise(() => {}));
    renderEntryListPage();

    expect(screen.getByText('loading...')).toBeInTheDocument();
  });

  it('shows the entries', async () => {
    SimpressMock.getEntriesByPage.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    SimpressMock.getRecentEntries.mockResolvedValue([testEntryData]);
    renderEntryListPage();
    act(() => {
      vi.runAllTimers();
    });

    const entries = await screen.findAllByRole('listitem', { name: 'entry' });
    expect(entries).toHaveLength(1);
  });

  it('shows Not Found on error', async () => {
    SimpressMock.getEntriesByPage.mockRejectedValue(new Error('ERR'));
    renderEntryListPage();
    act(() => {
      vi.runAllTimers();
    });

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });
});
