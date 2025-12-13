import { generatePath, Link } from 'react-router-dom';

const CreatedAt = ({ dateString }: { dateString: string }): React.JSX.Element | null => {
  const date = new Date(dateString);

  if (isNaN(date.getTime())) {
    return null;
  }

  const twoDigitMonth = (date.getMonth() + 1).toString().padStart(2, '0');
  const linkTo = generatePath('/archives/:year/:month', { year: date.getFullYear().toString(), month: twoDigitMonth });

  return (
    <time dateTime={dateString}>
      <Link to={linkTo}>{date.toLocaleDateString('sv-SE', { year: 'numeric', month: '2-digit', day: '2-digit' })}</Link>
    </time>
  );
};

export default CreatedAt;
