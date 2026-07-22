import { render, screen, type RenderResult } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import PostCategories from '../../../src/components/ui/PostCategories';
import type { TaxonomiesType } from '../../../src/types';

const renderWithRouter = (taxonomies: TaxonomiesType): RenderResult => {
  return render(
    <MemoryRouter>
      <PostCategories taxonomies={taxonomies} />
    </MemoryRouter>
  );
};

describe('PostCategories', () => {
  const taxonomies: TaxonomiesType = {
    categories: [
      { key: 'ruby', name: 'Ruby' },
      { key: 'javascript', name: 'JavaScript' },
    ],
    tags: [
      { key: 'tips', name: 'Tips' },
    ],
  };

  it('renders a link for every term across all taxonomies', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'JavaScript' })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'Tips' })).toBeInTheDocument();
  });

  it('links to the correct taxonomy/term path', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toHaveAttribute('href', '/archives/categories/ruby');
    expect(screen.getByRole('link', { name: 'Tips' })).toHaveAttribute('href', '/archives/tags/tips');
  });

  it('applies the post-category class to each link', () => {
    renderWithRouter(taxonomies);

    expect(screen.getByRole('link', { name: 'Ruby' })).toHaveClass('post-category');
  });

  it('renders no links when taxonomies is empty', () => {
    renderWithRouter({});

    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });

  it('renders no links when a taxonomy has no terms', () => {
    renderWithRouter({ categories: [] });

    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });
});
