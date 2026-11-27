import { useParams } from 'react-router';

export const usePermalink = (): string | null => {
  const { '*': permalink } = useParams<{ '*': string }>();

  if (permalink === undefined || permalink === '' || permalink.endsWith('/')) {
    return null;
  }

  return `/${permalink.replace(/(\.[^/.]+)?$/, '.json')}`;
};
