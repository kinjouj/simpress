import { render, screen } from '@testing-library/react';
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
    vi.spyOn(window, 'scrollTo').mockImplementation(() => {});
  });

  it('shows a loading indicator (not a blank screen) while entries are being fetched', () => {
    SimpressMock.getEntriesByPage.mockReturnValue(new Promise(() => {}));
    const { container } = renderEntryListPage();

    expect(screen.getByText('loading...')).toBeInTheDocument();
    expect(container).not.toBeEmptyDOMElement();
  });

  it('<EntryListPage> test', async () => {
    SimpressMock.getEntriesByPage.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    SimpressMock.getRecentEntries.mockResolvedValue([testEntryData]);
    renderEntryListPage();

    const entries = await screen.findAllByRole('listitem', { name: 'entry' }, { timeout: 10000 });
    expect(entries).toHaveLength(1);
  });

  it('Simpress.getEntriesByPageがエラーを吐いた場合', async () => {
    SimpressMock.getEntriesByPage.mockRejectedValue(new Error('ERR'));
    renderEntryListPage();

    expect(await screen.findByText('Not Found', {}, { timeout: 10000 })).toBeInTheDocument();
  });
});
