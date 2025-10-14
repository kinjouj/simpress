import { Link } from 'react-router-dom';

const CreatedAt = ({ dateString }: { dateString: string }): React.JSX.Element => {
  const date = new Date(dateString);
  const twoDigitMonth = (date.getMonth() + 1).toString().padStart(2, '0');
  const linkTo = `/archives/${date.getFullYear()}/${twoDigitMonth}`;

  return (
    <time dateTime={dateString}>
      <Link to={linkTo}>{date.toLocaleDateString('sv-SE', { year: 'numeric', month: '2-digit', day: 'numeric' })}</Link>
    </time>
  );
};

export default CreatedAt;
