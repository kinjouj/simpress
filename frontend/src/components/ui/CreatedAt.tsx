import { generatePath, Link } from 'react-router';
import type { DateType } from '../../types';

const CreatedAt = ({ date }: { date: DateType | null }): React.JSX.Element | null => {
  if (date === null) {
    return null;
  }

  const year = date.year.toString();
  const month = date.month.toString().padStart(2, '0');
  const day = date.day.toString().padStart(2, '0');
  const text = `${year}-${month}-${day}`;
  const linkTo = generatePath('/archives/:year/:month', { year, month });

  return (
    <time dateTime={text}>
      <Link to={linkTo}>{text}</Link>
    </time>
  );
};

export default CreatedAt;
