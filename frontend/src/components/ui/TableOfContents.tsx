import { useCallback } from 'react';
import type { TocType } from '../../types';

type FlatToc = {
  id: string
  text: string
  depth: number
};

const flattenToc = (toc: TocType[]): FlatToc[] => {
  return toc.flatMap((item) => [
    { id: item.id, text: item.text, depth: 0 },
    ...item.children.map((child) => ({ id: child.id, text: child.text, depth: 1 })),
  ]);
};

const TableOfContents = ({ toc }: { toc: TocType[] }): React.JSX.Element | null => {
  const scrollToSection = useCallback((event: React.MouseEvent<HTMLAnchorElement>) => {
    event.preventDefault();
    const id = event.currentTarget.getAttribute('href')?.slice(1);

    if (id !== undefined) {
      document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' });
    }
  }, []);

  if (toc.length <= 1) {
    return null;
  }

  return (
    <div className="post-toc rounded-3 p-2">
      <h6 className="text-center">Table of Contents</h6>
      {flattenToc(toc).map((item) => (
        <a key={item.id} href={`#${item.id}`} className={`d-block p-1 overflow-hidden ms-${Math.min(item.depth, 5)}`} onClick={scrollToSection}>
          {item.text}
        </a>
      ))}
    </div>
  );
};

export default TableOfContents;
