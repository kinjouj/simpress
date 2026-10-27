import { useParams } from 'react-router';

export const useCategory = (): string | null => {
  const { category } = useParams<{ category: string | undefined }>();
  return category ?? null;
};
