import { Link } from 'react-router-dom';
import { usePaginateContext } from '../../contexts/PagenateContext';

const Paginator = ({ basePath }: { basePath: string }): React.JSX.Element => {
  const { page, totalPages } = usePaginateContext();

  return (
    <div className="paginator d-flex my-5">
      {page > 1 && (<Link to={`${basePath}/${page - 1}`} rel="prev">Prev</Link>)}
      {totalPages > page && (<Link to={`${basePath}/${page + 1}`} rel="next">Next</Link>)}
    </div>
  );
};

export default Paginator;
