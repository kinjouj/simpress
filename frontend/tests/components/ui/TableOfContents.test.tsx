import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import TableOfContents from '../../../src/components/ui/TableOfContents';
import { testEntryData } from '../../fixtures/testEntryData';
import type { TocType } from '../../../src/types';

describe('TableOfContents', () => {
  it('hides single item without children', () => {
    const toc: TocType[] = [testEntryData.toc[0]];
    const { container } = render(<TableOfContents toc={toc} />);

    expect(container).toBeEmptyDOMElement();
  });

  it('shows single item with children', () => {
    const toc: TocType[] = [{ id: 'section-1', text: 'Intro', children: [{ id: 'section-1-1', text: 'Intro Detail' }] }];
    render(<TableOfContents toc={toc} />);

    expect(screen.getByText('Table of Contents')).toBeInTheDocument();
    expect(screen.getAllByRole('link').map((link) => link.textContent)).toEqual(['Intro', 'Intro Detail']);
  });

  it('shows headings and links', () => {
    render(<TableOfContents toc={testEntryData.toc} />);

    expect(screen.getByText('Table of Contents')).toBeInTheDocument();
    expect(screen.getByRole('link', { name: testEntryData.toc[0].text })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: testEntryData.toc[1].text })).toBeInTheDocument();
  });

  it('links to section anchors', () => {
    render(<TableOfContents toc={testEntryData.toc} />);

    expect(screen.getByRole('link', { name: testEntryData.toc[0].text })).toHaveAttribute('href', `#${testEntryData.toc[0].id}`);
    expect(screen.getByRole('link', { name: testEntryData.toc[1].text })).toHaveAttribute('href', `#${testEntryData.toc[1].id}`);
  });

  it('flattens and indents children', () => {
    const toc: TocType[] = [
      { id: 'section-1', text: 'Intro', children: [{ id: 'section-1-1', text: 'Intro Detail' }] },
      { id: 'section-2', text: 'Summary', children: [] },
    ];
    render(<TableOfContents toc={toc} />);

    const links = screen.getAllByRole('link').map((link) => link.textContent);
    expect(links).toEqual(['Intro', 'Intro Detail', 'Summary']);

    expect(screen.getByRole('link', { name: 'Intro' })).toHaveClass('ms-0');
    expect(screen.getByRole('link', { name: 'Intro Detail' })).toHaveClass('ms-1');
    expect(screen.getByRole('link', { name: 'Summary' })).toHaveClass('ms-0');
    expect(screen.getByRole('link', { name: 'Intro Detail' })).toHaveAttribute('href', '#section-1-1');
  });

  describe('when a link is clicked', () => {
    it('prevents default navigation', () => {
      render(<TableOfContents toc={testEntryData.toc} />);

      const link = screen.getByRole('link', { name: testEntryData.toc[0].text });
      const clickEvent = new MouseEvent('click', { bubbles: true, cancelable: true });
      link.dispatchEvent(clickEvent);
      expect(clickEvent.defaultPrevented).toBe(true);
    });

    it('scrolls to the section', async () => {
      render(<TableOfContents toc={testEntryData.toc} />);

      const target = document.createElement('div');
      target.id = testEntryData.toc[0].id;
      document.body.appendChild(target);

      const scrollIntoView = vi.fn();
      target.scrollIntoView = scrollIntoView;

      const user = userEvent.setup();
      await user.click(screen.getByRole('link', { name: testEntryData.toc[0].text }));
      expect(scrollIntoView).toHaveBeenCalledWith({ behavior: 'smooth' });

      document.body.removeChild(target);
    });

    it('ignores missing sections', async () => {
      render(<TableOfContents toc={testEntryData.toc} />);

      const user = userEvent.setup();
      await expect(user.click(screen.getByRole('link', { name: testEntryData.toc[0].text }))).resolves.not.toThrow();
    });
  });
});
