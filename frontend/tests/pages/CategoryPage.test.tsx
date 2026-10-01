import { render, screen } from '@testing-library/react';
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
    vi.spyOn(window, 'scrollTo').mockImplementation(() => {});
  });

  test('<CategoryPage> test', async () => {
    SimpressMock.getEntriesByCategory.mockResolvedValue({ entries: [testEntryData], total_pages: 1 });
    SimpressMock.getRecentEntries.mockResolvedValue([testEntryData]);
    renderCategoryEntryListPage();

    const entries = await screen.findAllByRole('listitem', { name: 'entry' }, { timeout: 10000 });
    expect(entries).toHaveLength(1);
  });

  test('useCategoryがnullを返した場合', async () => {
    render(
      <MemoryRouter>
        <CategoryPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getEntriesByCategoryがエラーを吐いた場合', async () => {
    SimpressMock.getEntriesByCategory.mockRejectedValue(new Error('ERROR'));
    renderCategoryEntryListPage();

    expect(await screen.findByText('Not Found', {}, { timeout: 10000 })).toBeInTheDocument();
  });
});
