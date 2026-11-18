import { render, screen, type RenderResult } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import Paginator from '../../../src/components/ui/Paginator';
import { PaginateProvider } from '../../../src/contexts/PaginateContext';

const renderWithContext = (value: { page: number, totalPages: number }): RenderResult => {
  return render(
    <MemoryRouter>
      <PaginateProvider value={value}>
        <Paginator basePath="/page" />
      </PaginateProvider>
    </MemoryRouter>
  );
};

describe('Paginator', () => {
  it('shows Prev and Next midway', () => {
    renderWithContext({ page: 2, totalPages: 5 });

    expect(screen.getByRole('link', { name: 'Prev' })).toHaveAttribute('href', '/page/1');
    expect(screen.getByRole('link', { name: 'Next' })).toHaveAttribute('href', '/page/3');
  });

  it('hides Prev on first page', () => {
    renderWithContext({ page: 1, totalPages: 5 });

    expect(screen.queryByRole('link', { name: 'Prev' })).not.toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'Next' })).toHaveAttribute('href', '/page/2');
  });

  it('hides Next on last page', () => {
    renderWithContext({ page: 5, totalPages: 5 });

    expect(screen.getByRole('link', { name: 'Prev' })).toHaveAttribute('href', '/page/4');
    expect(screen.queryByRole('link', { name: 'Next' })).not.toBeInTheDocument();
  });
});
