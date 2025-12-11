import { useState, useEffect, useMemo } from 'react';
import { Link } from 'react-router-dom';
import { chunkIt } from '@array-utils/chunk-it';
import { usePage } from '../../hooks';
import Simpress from '../../api/Simpress';

const PAGE_PER_SIZE = 10;

const Pager = (): React.JSX.Element | null => {
  const [maxPage, setMaxPage] = useState<number>(1);
  const currentPage = usePage();

  useEffect(() => {
    const fetchPageInfo = async (): Promise<void> => {
      try {
        const page = await Simpress.getPageInfo();
        setMaxPage(page);
      } catch {
        setMaxPage(0);
      }
    };
    void fetchPageInfo();
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
              <li key="prev-page" className="page-item">
                <Link className="page-link" to={`/page/${currentPage - 1}`}>&lt;&lt;</Link>
              </li>
            )}
            {pages.map((page) => {
              return (
                <li key={page} className={`page-item ${page === currentPage ? 'active' : ''}`}>
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
              <li key="next-page" className="page-item">
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
