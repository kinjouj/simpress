import { useParams } from 'react-router-dom';

export const useCategory = (): string | null => {
  const { category } = useParams<{ category: string | undefined }>();
  return category ?? null;
};
