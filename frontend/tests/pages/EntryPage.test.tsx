import { act, render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router';
import EntryPage from '../../src/pages/EntryPage';
import Simpress from '../../src/api/Simpress';
import { testEntryData } from '../fixtures/testEntryData';
import type { RenderResult } from '@testing-library/react';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

const renderEntryPage = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/test.json']}>
      <Routes>
        <Route path="/*" element={<EntryPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('EntryPage', () => {
  beforeEach(() => {
    vi.useFakeTimers({ shouldAdvanceTime: true });
    vi.spyOn(window, 'scrollTo').mockImplementation(() => {});
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('<EntryPage> test', async () => {
    SimpressMock.getEntry.mockResolvedValue(testEntryData);
    SimpressMock.getRecentEntries.mockResolvedValue([testEntryData]);
    renderEntryPage();
    act(() => {
      vi.runAllTimers();
    });

    const entry = await screen.findByRole('article');
    expect(entry).toBeInTheDocument();
  });

  it('usePermalinkがnullを返した場合', async () => {
    render(
      <MemoryRouter>
        <EntryPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  it('Simpress.getEntryがエラーを出した場合', async () => {
    SimpressMock.getEntry.mockRejectedValue(new Error('ERROR'));
    renderEntryPage();
    act(() => {
      vi.runAllTimers();
    });

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });
});
