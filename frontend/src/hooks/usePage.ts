import { useParams } from 'react-router-dom';

export const usePage = (): number => {
  const { page = '1' } = useParams();
  return parseInt(page, 10);
};
