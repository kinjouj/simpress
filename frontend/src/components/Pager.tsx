import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Simpress from '../simpress';
import { usePage } from '../hooks';

const Pager = (): React.JSX.Element => {
  const [pages, setPages] = useState<number[]>([]);
  const currentPage = usePage();

  useEffect(() => {
    Simpress.getPageInfo().then((page) => {
      setPages(Array.from({ length: page }, (_, i) => i + 1));
    }).catch(() => {
      // noop
    });
  }, []);

  return (
    <>
      {pages.map((page) => {
        if (page == currentPage) {
          return (
            <span key={page} style={{ margin: '3px' }}>{page}</span>
          );
        } else {
          return (
            <Link key={page} to={`/page/${page}`} style={{ margin: '3px' }}>{page}</Link>
          );
        }
      })}
    </>
  );
};

export default Pager;
