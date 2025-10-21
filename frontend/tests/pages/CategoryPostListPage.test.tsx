import { act, render, screen, waitFor } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import CategoryPostListPage from '../../src/pages/CategoryPostListPage';
import type Simpress from '../../src/simpress';
import type { PostType } from '../../src/types';
import type { RenderResult } from '@testing-library/react';
import '@testing-library/jest-dom';

const mockGetPostsByCategory = jest.fn<Promise<PostType[]>, [string]>();
jest.mock('../../src/simpress', (): Simpress => ({
  getPostsByCategory: (category: string) => mockGetPostsByCategory(category),
}));

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
        <Route path="/archives/category/:category" element={<CategoryPostListPage />} />
      </Routes>
    </MemoryRouter>
  );
};

describe('CategoryPostListPage', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    jest.clearAllMocks();
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  test('<CategoryPostListPage> test', async () => {
    mockGetPostsByCategory.mockResolvedValue([testData]);
    renderCategortPostListPage();

    await waitFor(() => expect(mockGetPostsByCategory).toHaveBeenCalled());
    await act(async () => {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    });

    const posts = await screen.findAllByRole('list');
    expect(posts).toHaveLength(1);
  });

  test('useCategoryがnullを返した場合', () => {
    render(
      <MemoryRouter>
        <CategoryPostListPage />
      </MemoryRouter>
    );

    expect(screen.queryByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostsByCategoryがエラーを吐いた場合', async () => {
    mockGetPostsByCategory.mockRejectedValue(new Error('ERROR'));
    renderCategortPostListPage();

    await waitFor(() => {
      expect(screen.queryByText('Not Found')).toBeInTheDocument();
    });
  });
});
