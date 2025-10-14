import { useState, useEffect } from 'react';
import { chunkIt } from '@array-utils/chunk-it';
import { Link } from 'react-router-dom';
import Simpress from '../simpress';
import { usePage } from '../hooks';

const Pager = (): React.JSX.Element => {
  const [maxPage, setMaxPage] = useState<number>(1);
  const [pages, setPages] = useState<number[]>([]);
  const currentPage = usePage();

  useEffect(() => {
    Simpress.getPageInfo().then((page) => {
      const chunks = chunkIt(Array.from({ length: page }, (_, i) => i + 1)).size(10);
      setMaxPage(page);
      setPages(chunks[Math.ceil(currentPage / 10) - 1] as number[]);
    }).catch(() => {
      // noop
    });
  }, [currentPage]);

  return (
    <div className="row justify-content-center">
      <div className="col col-lg-8">
        <nav>
          <ul className="pagination">
            {currentPage > 1 && (
              <li className="page-item" key="prev-page">
                <Link className="page-link" to={`/page/${currentPage - 1}`}>&lt;&lt;</Link>
              </li>
            )}
            {pages.map((page) => {
              if (page === currentPage) {
                return (
                  <li className="page-item" key={page}>
                    <Link className="page-link" to="#">{page}</Link>
                  </li>
                );
              } else {
                return (
                  <li className="page-item" key={page}>
                    <Link className="page-link" to={`/page/${page}`}>{page}</Link>
                  </li>
                );
              }
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
