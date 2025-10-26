import { useState, useEffect, useMemo } from 'react';
import { Link } from 'react-router-dom';
import { chunkIt } from '@array-utils/chunk-it';
import Simpress from '../../api/Simpress';
import { usePage } from '../../hooks';

const PAGE_PER_SIZE = 10;

const Pager = (): React.JSX.Element | null => {
  const [maxPage, setMaxPage] = useState<number>(1);
  const currentPage = usePage();

  useEffect(() => {
    void (async (): Promise<void> => {
      try {
        const page = await Simpress.getPageInfo();
        setMaxPage(page);
      } catch {
        setMaxPage(0);
      }
    })();
  }, []);

  const pages = useMemo(() => {
    if (maxPage > 0) {
      const chunks: number[][] = chunkIt(Array.from({ length: maxPage }, (_, i) => i + 1)).size(PAGE_PER_SIZE) as number[][];
      return chunks[Math.ceil(currentPage / PAGE_PER_SIZE) - 1] ?? [];
    }

    return [];
  }, [maxPage, currentPage]);

  if (maxPage <= 1) {
    return null;
  }

  return (
    <div className="row justify-content-center">
      <div className="col col-lg-8">
        <nav>
          <ul className="pagination justify-content-center">
            {currentPage > 1 && (
              <li className="page-item" key="prev-page">
                <Link className="page-link" to={`/page/${currentPage - 1}`}>&lt;&lt;</Link>
              </li>
            )}
            {pages.map((page) => {
              return (
                <li className={`page-item ${page === currentPage ? 'active' : ''}`} key={page}>
                  {page === currentPage
                    ? (
                        <span className="page-link">{page}</span>
                      )
                    : (
                        <Link className="page-link" to={`/page/${page}`}>{page}</Link>
                      )}
                </li>
              );
            })}
            {maxPage > currentPage && (
              <li className="page-item" key="next-page">
                <Link className="page-link" to={`/page/${currentPage + 1}`}>&gt;&gt;</Link>
              </li>
            )}
          </ul>
        </nav>
      </div>
    </div>
  );
};

export default Pager;
