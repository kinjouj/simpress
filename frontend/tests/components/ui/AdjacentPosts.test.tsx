import { render, screen, type RenderResult } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import AdjacentPosts from '../../../src/components/ui/AdjacentPosts';
import type { PostLinkType } from '../../../src/types';

const renderWithRouter = ({ next, prev }: { next: PostLinkType | null, prev: PostLinkType | null }): RenderResult => {
  return render(
    <MemoryRouter>
      <AdjacentPosts next={next} prev={prev} />
    </MemoryRouter>
  );
};

describe('AdjacentPosts', () => {
  const nextSummary = {
    id: 'post-456',
    title: 'Newer Post',
    permalink: '/newer-post',
  };

  const prevSummary = {
    id: 'post-789',
    title: 'Older Post',
    permalink: '/older-post',
  };

  it('renders both links when next and prev are present', () => {
    renderWithRouter({ next: nextSummary, prev: prevSummary });

    expect(screen.getByRole('link', { name: new RegExp(nextSummary.title) })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: new RegExp(prevSummary.title) })).toBeInTheDocument();
  });

  it('links to the correct permalink with rel="prev" for next', () => {
    renderWithRouter({ next: nextSummary, prev: prevSummary });

    const link = screen.getByRole('link', { name: new RegExp(nextSummary.title) });
    expect(link).toHaveAttribute('href', nextSummary.permalink);
    expect(link).toHaveAttribute('rel', 'prev');
  });

  it('links to the correct permalink with rel="next" for prev', () => {
    renderWithRouter({ next: nextSummary, prev: prevSummary });

    const link = screen.getByRole('link', { name: new RegExp(prevSummary.title) });
    expect(link).toHaveAttribute('href', prevSummary.permalink);
    expect(link).toHaveAttribute('rel', 'next');
  });

  it('does not render the next link when next is null', () => {
    renderWithRouter({ next: null, prev: prevSummary });

    expect(screen.queryByRole('link', { name: new RegExp(nextSummary.title) })).not.toBeInTheDocument();
    expect(screen.getByRole('link', { name: new RegExp(prevSummary.title) })).toBeInTheDocument();
  });

  it('does not render the prev link when prev is null', () => {
    renderWithRouter({ next: nextSummary, prev: null });

    expect(screen.getByRole('link', { name: new RegExp(nextSummary.title) })).toBeInTheDocument();
    expect(screen.queryByRole('link', { name: new RegExp(prevSummary.title) })).not.toBeInTheDocument();
  });

  it('renders an empty container when both next and prev are null', () => {
    renderWithRouter({ next: null, prev: null });

    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });
});
