import { render, screen, type RenderResult } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import EntryCategories from '../../../src/components/ui/EntryCategories';
import type { TaxonomiesType } from '../../../src/types';

const renderWithRouter = (taxonomies: TaxonomiesType): RenderResult => {
  return render(
    <MemoryRouter>
      <EntryCategories taxonomies={taxonomies} />
    </MemoryRouter>
  );
};

describe('EntryCategories', () => {
  const taxonomies: TaxonomiesType = {
    categories: [
      { key: 'ruby', name: 'Ruby' },
      { key: 'javascript', name: 'JavaScript' },
    ],
    tags: [
      { key: 'tips', name: 'Tips' },
    ],
  };

  it('shows term links', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'JavaScript' })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'Tips' })).toBeInTheDocument();
  });

  it('links to taxonomy term paths', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toHaveAttribute('href', '/archives/categories/ruby');
    expect(screen.getByRole('link', { name: 'Tips' })).toHaveAttribute('href', '/archives/tags/tips');
  });

  it('adds entry-category class', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toHaveClass('entry-category');
  });

  it('shows no links when empty', () => {
    renderWithRouter({});

    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });

  it('hides taxonomies without terms', () => {
    renderWithRouter({ categories: [] });

    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });
});
