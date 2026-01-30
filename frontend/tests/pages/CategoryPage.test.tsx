import { act, render, screen } from '@testing-library/react';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import CategoryPage from '../../src/pages/CategoryPage';
import Simpress from '../../src/api/Simpress';
import { testPostData } from '../fixtures/testPostData';
import type { RenderResult } from '@testing-library/react';

jest.mock('../../src/api/Simpress');
const SimpressMock = jest.mocked(Simpress);

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
    jest.clearAllTimers();
  });

  test('<CategoryPage> test', async () => {
    SimpressMock.getPostsByCategory.mockResolvedValue([testPostData]);
    SimpressMock.getRecentPosts.mockResolvedValue([testPostData]);
    renderCategortPostListPage();
    act(() => {
      jest.runAllTimers();
    });

    const posts = await screen.findAllByRole('listitem', { name: 'post' });
    expect(posts).toHaveLength(1);
  });

  test('useCategoryがnullを返した場合', async () => {
    render(
      <MemoryRouter>
        <CategoryPage />
      </MemoryRouter>
    );

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });

  test('Simpress.getPostsByCategoryがエラーを吐いた場合', async () => {
    SimpressMock.getPostsByCategory.mockRejectedValue(new Error('ERROR'));
    renderCategortPostListPage();
    act(() => {
      jest.runAllTimers();
    });

    expect(await screen.findByText('Not Found')).toBeInTheDocument();
  });
});
