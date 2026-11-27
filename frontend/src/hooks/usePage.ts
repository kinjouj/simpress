import { useParams } from 'react-router';

export const usePage = (): number => {
  const { page = '1' } = useParams();
  const parsed = parseInt(page, 10);

  return Number.isNaN(parsed) || parsed < 1 ? 1 : parsed;
};
