import { render, screen, type RenderResult } from '@testing-library/react';
import { MemoryRouter } from 'react-router';
import AdjacentEntries from '../../../src/components/ui/AdjacentEntries';
import type { EntryLinkType } from '../../../src/types';

const renderWithRouter = ({ next, prev }: { next: EntryLinkType | null, prev: EntryLinkType | null }): RenderResult => {
  return render(
    <MemoryRouter>
      <AdjacentEntries next={next} prev={prev} />
    </MemoryRouter>
  );
};

describe('AdjacentEntries', () => {
  const nextSummary = {
    id: 'entry-456',
    title: 'Newer Entry',
    permalink: '/newer-entry',
  };

  const prevSummary = {
    id: 'entry-789',
    title: 'Older Entry',
    permalink: '/older-entry',
  };

  it('nextとprevがある場合は両方のリンクを表示する', () => {
    renderWithRouter({ next: nextSummary, prev: prevSummary });

    expect(screen.getByRole('link', { name: new RegExp(nextSummary.title) })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: new RegExp(prevSummary.title) })).toBeInTheDocument();
  });

  it('nextはpermalinkへrel="prev"でリンクする', () => {
    renderWithRouter({ next: nextSummary, prev: prevSummary });

    const link = screen.getByRole('link', { name: new RegExp(nextSummary.title) });
    expect(link).toHaveAttribute('href', nextSummary.permalink);
    expect(link).toHaveAttribute('rel', 'prev');
  });

  it('prevはpermalinkへrel="next"でリンクする', () => {
    renderWithRouter({ next: nextSummary, prev: prevSummary });

    const link = screen.getByRole('link', { name: new RegExp(prevSummary.title) });
    expect(link).toHaveAttribute('href', prevSummary.permalink);
    expect(link).toHaveAttribute('rel', 'next');
  });

  it('nextがnullの場合はnextリンクを表示しない', () => {
    renderWithRouter({ next: null, prev: prevSummary });

    expect(screen.queryByRole('link', { name: new RegExp(nextSummary.title) })).not.toBeInTheDocument();
    expect(screen.getByRole('link', { name: new RegExp(prevSummary.title) })).toBeInTheDocument();
  });

  it('prevがnullの場合はprevリンクを表示しない', () => {
    renderWithRouter({ next: nextSummary, prev: null });

    expect(screen.getByRole('link', { name: new RegExp(nextSummary.title) })).toBeInTheDocument();
    expect(screen.queryByRole('link', { name: new RegExp(prevSummary.title) })).not.toBeInTheDocument();
  });

  it('nextとprevが両方nullの場合は空のコンテナを表示する', () => {
    renderWithRouter({ next: null, prev: null });

    expect(screen.queryByRole('link')).not.toBeInTheDocument();
  });
});
