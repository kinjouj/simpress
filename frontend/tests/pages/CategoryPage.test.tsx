import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import CategoryPage from '../../src/pages/CategoryPage';
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

const renderCategortPostListPage = (): RenderResult => {
  return render(
    <MemoryRouter initialEntries={['/archives/category/test']}>
      <Routes>
        <Route path="/archives/category/:category" element={<CategoryPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('CategoryPage', () => {
  beforeEach(() => {
    jest.useFakeTimers();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('<CategoryPage> test', async () => {
    SimpressMock.getPostsByCategory.mockResolvedValue([testData]);
    renderCategortPostListPage();

    await waitFor(() => expect(SimpressMock.getPostsByCategory).toHaveBeenCalled());
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('useCategoryがnullを返した場合', () => {
    render(
      <MemoryRouter>
        <CategoryPage />
      </MemoryRouter>
    );

    expect(screen.queryByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostsByCategoryがエラーを吐いた場合', async () => {
    SimpressMock.getPostsByCategory.mockRejectedValue(new Error('ERROR'));
    renderCategortPostListPage();

    await waitFor(() => {
      expect(screen.queryByText('Not Found')).toBeInTheDocument();
    });
  });
});
