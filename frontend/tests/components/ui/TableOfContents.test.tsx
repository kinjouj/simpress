import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import TableOfContents from '../../../src/components/ui/TableOfContents';
import { testPostData } from '../../fixtures/testPostData';
import type { TocType } from '../../../src/types';

describe('TableOfContents', () => {
  it('renders nothing when toc has only 1 item', () => {
    const toc: TocType[] = [testPostData.toc[0]];
    const { container } = render(<TableOfContents toc={toc} />);

    expect(container).toBeEmptyDOMElement();
  });

  it('renders the heading and links when toc has more than 1 item', () => {
    render(<TableOfContents toc={testPostData.toc} />);

    expect(screen.getByText('Table of Contents')).toBeInTheDocument();
    expect(screen.getByRole('link', { name: testPostData.toc[0].text })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: testPostData.toc[1].text })).toBeInTheDocument();
  });

  it('links to the anchor built from the section id', () => {
    render(<TableOfContents toc={testPostData.toc} />);

    expect(screen.getByRole('link', { name: testPostData.toc[0].text })).toHaveAttribute('href', `#${testPostData.toc[0].id}`);
    expect(screen.getByRole('link', { name: testPostData.toc[1].text })).toHaveAttribute('href', `#${testPostData.toc[1].id}`);
  });

  it('flattens, indents, and links children relative to their parent', () => {
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
    it('prevents the default navigation', () => {
      render(<TableOfContents toc={testPostData.toc} />);

      const link = screen.getByRole('link', { name: testPostData.toc[0].text });
      const clickEvent = new MouseEvent('click', { bubbles: true, cancelable: true });
      link.dispatchEvent(clickEvent);

      expect(clickEvent.defaultPrevented).toBe(true);
    });

    it('scrolls the target section into view', async () => {
      render(<TableOfContents toc={testPostData.toc} />);

      const target = document.createElement('div');
      target.id = testPostData.toc[0].id;
      document.body.appendChild(target);
      const scrollIntoView = jest.fn();
      target.scrollIntoView = scrollIntoView;

      const user = userEvent.setup();
      await user.click(screen.getByRole('link', { name: testPostData.toc[0].text }));

      expect(scrollIntoView).toHaveBeenCalledWith({ behavior: 'smooth' });

      document.body.removeChild(target);
    });

    it('does not throw when the target section does not exist', async () => {
      render(<TableOfContents toc={testPostData.toc} />);

      const user = userEvent.setup();
      await expect(user.click(screen.getByRole('link', { name: testPostData.toc[0].text }))).resolves.not.toThrow();
    });
  });
});
