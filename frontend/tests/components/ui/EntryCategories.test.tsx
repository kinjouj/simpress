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

  test('renders a link for every term across all taxonomies', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'JavaScript' })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'Tips' })).toBeInTheDocument();
  });

  test('links to the correct taxonomy/term path', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toHaveAttribute('href', '/archives/categories/ruby');
    expect(screen.getByRole('link', { name: 'Tips' })).toHaveAttribute('href', '/archives/tags/tips');
  });

  test('applies the entry-category class to each link', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toHaveClass('entry-category');
  });

  test('renders no links when taxonomies is empty', () => {
    renderWithRouter({});

    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });

  test('renders no links when a taxonomy has no terms', () => {
    renderWithRouter({ categories: [] });

    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });
});
