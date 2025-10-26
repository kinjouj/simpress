import { useParams } from 'react-router-dom';

export const usePermalink = (): string | null => {
  const { '*': permalink } = useParams<{ '*': string | undefined }>();
  return permalink ?? null;
};
