import { useParams } from 'react-router-dom';

export const usePermalink = (): string | null => {
  let { '*': permalink } = useParams<{ '*': string }>();

  if (permalink !== undefined) {
    const jsonPath = permalink.replace(/(\.[^/.]+)?$/, '.json');
    permalink = `/${jsonPath}`;
  }

  return permalink ?? null;
};
