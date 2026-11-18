import { act, render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router';
import CategoryPage from '../../src/pages/CategoryPage';
import Simpress from '../../src/api/Simpress';
import { testEntryData } from '../fixtures/testEntryData';
import type { RenderResult } from '@testing-library/react';

vi.mock('../../src/api/Simpress');
const SimpressMock = vi.mocked(Simpress);

const renderCategoryEntryListPage = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/archives/category/test/1']}>
      <Routes>
        <Route path="/archives/category/:category/:page" element={<CategoryPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('CategoryPage', () => {
  beforeEach(() => {
    vi.useFakeTimers({ shouldAdvanceTime: true });
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('shows category entries', async () => {
    SimpressMock.getEntriesByCategory.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    SimpressMock.getRecentEntries.mockResolvedValue([testEntryData]);
    renderCategoryEntryListPage();
    act(() => {
      vi.runAllTimers();
    });

    const entries = await screen.findAllByRole('listitem', { name: 'entry' });
    expect(entries).toHaveLength(1);
  });

  it('shows Not Found if null', async () => {
    render(
      <MemoryRouter>
        <CategoryPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  it('shows Not Found on error', async () => {
    SimpressMock.getEntriesByCategory.mockRejectedValue(new Error('ERROR'));
    renderCategoryEntryListPage();
    act(() => {
      vi.runAllTimers();
    });

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });
});
