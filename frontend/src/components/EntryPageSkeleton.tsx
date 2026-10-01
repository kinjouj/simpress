import Skeleton, { SkeletonTheme } from 'react-loading-skeleton';
import 'react-loading-skeleton/dist/skeleton.css';

const EntryPageSkeleton = (): React.JSX.Element => {
  return (
    <SkeletonTheme baseColor="#e0e0e0" highlightColor="#f5f5f5">
      <article className="entry mx-4 mb-5">
        <div className="entry-date my-2">
          <Skeleton height={50} />
        </div>
        <div className="entry-title my-3">
          <Skeleton height={80} />
        </div>
        <hr />
        <Skeleton height={50} className="entry-categories m-0" />
        <div className="entry-content my-4 mw-100">
          <Skeleton height={300} />
        </div>
      </article>
    </SkeletonTheme>
  );
};

export default EntryPageSkeleton;
